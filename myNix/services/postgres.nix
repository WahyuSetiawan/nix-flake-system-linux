{ inputs, pkgs, config, pc, ... }:
let
  dbName = "sample";
in
{
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services.postgres."pg1" = {
    enable = true;
    initialDatabases = [
      {
        name = dbName;
        # schemas = [ "${inputs.northwind}/northwind.sql" ];
      }
    ];
  };

  settings.processes.pgweb =
    let
      pgcfg = pc.config.services.postgres.pg1;
    in
    {
      environment.PGWEB_DATABASE_URL = pgcfg.connectionURI { inherit dbName; };
      command = pkgs.pgweb;
      depends_on."pg1".condition = "process_healthy";
    };
  settings.processes.test = {
    command = pkgs.writeShellApplication {
      name = "pg1-test";
      runtimeInputs = [ pc.config.services.postgres.pg1.package ];
      text = ''
        echo 'SELECT version();' | psql -h 127.0.0.1 ${dbName}
      '';
    };
    depends_on."pg1".condition = "process_healthy";
  };
}
