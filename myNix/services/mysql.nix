{ inputs, pc, lib, pkgs, ... }: {
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services = {
    mysql."mysql1".enable = true;
  };

  settings.process.mysqlweb = { 
    command = pkgs.adminer;
    depends_on."mysql1".condition = "process_healthy";
  };
}
