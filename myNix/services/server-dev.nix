{ inputs, pkgs, config, pc, lib, ... }:
let
  inherit (inputs.self.util) getEnv;

  projectName = getEnv "PROJECT_NAME" "default";

  postgresDbName = getEnv "POSTGRES_DB_NAME" "sample";
  portgresPort = getEnv "POSTGRES_PORT" "5432";
  postgresListen = getEnv "POSTGRES_LISTEN" "127.0.0.1";
  postgresSchema = getEnv "POSTGRES_SCHEMA" "";

  postgresUser = getEnv "POSTGRES_USER" "dev_user";
  postgresPass = getEnv "POSTGRES_PASS" "my_password";

  databaseName = getEnv "MYSQL_DATABASE" "my_project";
  mysqlSocketDir = getEnv "MYSQL_SOCKET_DIR" "";
  enableMysql = getEnv "ENABLE_MYSQL" "";
  mysqlPort = getEnv "MYSQL_PORT" "3306";

  redisEnable = getEnv "REDIS_ENABLE" "";
  redisPost = getEnv "REDIS_PORT" "6379";

  minioEnable = getEnv "MINIO_ENABLE" "";

  pgwebPort = getEnv "PGWEB_PORT" "8081";

  dataDir = getEnv "DATA_DIR" "/tmp/myfolder-${toString (inputs.self.util.currentTime or 0)}";

in
{
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services.postgres."pg-${projectName}" = {
    enable = true;
    # dataDir = dataDir + "/postgres-${projectName}";
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

  # Option 1: Adminer (lightweight, supports multiple databases)
  settings.processes.adminer = {
    command = "${pkgs.adminer}/bin/adminer";
    environment = {
      ADMINER_DEFAULT_SERVER = "${postgresListen}:${portgresPort}";
    };
    depends_on."pg-${projectName}".condition = "process_healthy";
  };

  # # Option 2: pgAdmin (full-featured PostgreSQL administration)
  # settings.processes.pgadmin = {
  #   command = "${pkgs.pgadmin4}/bin/pgadmin4";
  #   environment = {
  #     PGADMIN_DEFAULT_EMAIL = "admin@example.com";
  #     PGADMIN_DEFAULT_PASSWORD = "admin";
  #     PGADMIN_LISTEN_PORT = "${pgwebPort}";
  #   };
  #   depends_on."pg-${projectName}".condition = "process_healthy";
  # };

  # # Option 3: PostgREST (Auto-generate REST API from PostgreSQL schema)
  # settings.processes.postgrest = {
  #   command = "${pkgs.postgrest}/bin/postgrest";
  #   environment = {
  #     PGRST_DB_URI = "postgres://${postgresUser}:${postgresPass}@${postgresListen}:${portgresPort}/${postgresDbName}";
  #     PGRST_DB_SCHEMA = postgresSchema;
  #     PGRST_SERVER_PORT = "${pgwebPort}";
  #   };
  #   depends_on."pg-${projectName}".condition = "process_healthy";
  # };

  # # Option 4: Keep original pgweb
  # settings.processes.pgweb =
  #   let
  #     pgcfg = pc.config.services.postgres."pg-${projectName}";
  #     dbName = postgresDbName;
  #   in
  #   {
  #     environment.PGWEB_DATABASE_URL = pgcfg.connectionURI {
  #       inherit dbName;
  #       user = postgresUser;
  #       password = postgresPass;
  #     };
  #     command = "${pkgs.pgweb}/bin/pgweb --bind=0.0.0.0 --listen=${pgwebPort}";
  #     depends_on."pg-${projectName}".condition = "process_healthy";
  #   };


  services.mysql."mysql_${projectName}" = lib.mkIf (enableMysql != "")
    ({
      enable = true;
      dataDir = dataDir + "mysql";
      settings.mysqld.port = mysqlPort;
      initialDatabases = [
        { name = databaseName; }
      ];
    } // lib.optionalAttrs (mysqlSocketDir != "") {
      socketDir = mysqlSocketDir;
    });


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


  services.redis."redis-${projectName}-dev" = {
    enable = true;
    port = builtins.fromJSON redisPost;
  };

  services.minio."minio-${projectName}-dev" = lib.mkIf (minioEnable != "") {
    enable = true;
  };
}
