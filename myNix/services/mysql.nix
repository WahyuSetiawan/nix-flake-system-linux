{ inputs, pc, lib, pkgs, ... }: {
  imports = [
    inputs.services-flake.processComposeModules.default
  ];

  services = {
    mysql."mysql1".enable = true;
  };
}
