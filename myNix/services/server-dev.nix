{ inputs, pkgs, config, pc, lib, ... }:
let
  inherit (inputs.self.util) getEnv;

  projectName = getEnv "PROJECT_NAME" "";

  postgresDbName = getEnv "POSTGRES_DB_NAME" "sample";
  portgresPort = getEnv "POSTGRES_PORT" "5432";
  postgresListen = getEnv "POSTGRES_LISTEN" "127.0.0.1";
  postgresSchema = getEnv "POSTGRES_SCHEMA" "";

  postgresUser = getEnv "POSTGRES_USER" "dev_user";
  postgresPass = getEnv "POSTGRES_PASS" "my_password";

  redisEnable = getEnv "REDIS_ENABLE" "";
  redisPost = getEnv "REDIS_PORT" "6379";
in
{
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services.postgres."pg-${projectName}" = {
    enable = true;
    port = builtins.fromJSON portgresPort;
    initialScript.before = ''
      CREATE USER ${postgresUser} WITH password '${postgresPass}';
      CREATE EXTENSION system_stats;
    '';
    extensions = exts: [
      exts.system_stats
    ];
    initialDatabases = [
      ({
        name = postgresDbName;
      }
      // lib.optionalAttrs (postgresSchema != "") {
        schemas = [ postgresSchema ];
      }
      )
    ];
  };

  settings.processes.pgweb =
    let
      pgcfg = pc.config.services.postgres."pg-${projectName}";
      dbName = postgresDbName;
    in
    {
      environment.PGWEB_DATABASE_URL = pgcfg.connectionURI {
        inherit dbName;
      };
      command = pkgs.pgweb;
      depends_on."pg-${projectName}".condition = "process_healthy";
    };

  settings.processes.test = {
    command = pkgs.writeShellApplication {
      name = "pg-${projectName}-test";
      runtimeInputs = [ pc.config.services.postgres."pg-${projectName}".package ];
      text = ''
        echo 'SELECT version();' | psql -h ${postgresListen} ${postgresDbName}
      '';
    };
    depends_on."pg-${projectName}".condition = "process_healthy";
  };


  services.redis."redis-dev" = {
    enable = redisEnable != "";
    port = builtins.toJSON redisPost;
  };
}
