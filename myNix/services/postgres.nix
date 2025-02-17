{ inputs, pkgs, config, ... }: {
  # `process-compose.foo` will add a flake package output called "foo".
  # Therefore, this will add a default package that you can build using
  # `nix build` and run using `nix run`.
  process-compose."default" = { config, ... }:
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
          pgcfg = config.services.postgres.pg1;
        in
        {
          environment.PGWEB_DATABASE_URL = pgcfg.connectionURI { inherit dbName; };
          command = pkgs.pgweb;
          depends_on."pg1".condition = "process_healthy";
        };
      settings.processes.test = {
        command = pkgs.writeShellApplication {
          name = "pg1-test";
          runtimeInputs = [ config.services.postgres.pg1.package ];
          text = ''
            echo 'SELECT version();' | psql -h 127.0.0.1 ${dbName}
          '';
        };
        depends_on."pg1".condition = "process_healthy";
      };
    };

  devShells.default = pkgs.mkShell {
    inputsFrom = [
      config.process-compose."default".services.outputs.devShell
    ];
    nativeBuildInputs = [ pkgs.just ];
  };
}
