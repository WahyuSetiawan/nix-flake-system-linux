all@{ ezModules, config, inputs, pkgs, lib, nixpkgs, ... }:
let
  allModules = builtins.attrNames all.config._module.args;
  # debug = builtins.trace "isi dari system ${lib.concatStringsSep ", " allModules}" allModules;
in
{
  imports =
    lib.lists.concatLists [
      (builtins.attrValues inputs.self.crossModules)
    ] ++
    [
      ezModules.hardware
      ezModules.system
    ];

  users.primaryUser = rec{
    username = "juragankoding";
    fullName = "Juragan Koding";
    email = "wahyu.creator911@gmail.com";
    pathHome = "home";
    nixConfigDirectory = "/home/${username}/.nix";
    within = {
      # hyprland.enable = true;
      # cinnamon.enable = true;
    };
  };

  users.users."juragankoding" = {
    isNormalUser = true;
    description = "Juragan Koding";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "adbusers"
      "docker"
    ];

    shell = pkgs.fish;
  };

  users.extraGroups.docker.members = [ "username-with-access-to-socket" ];

  system.stateVersion = builtins.trace "try this : ${builtins.toString allModules}" "24.11";

  nix.settings.trusted-users = [ "root" "juragankoding" ];
  nixpkgs.hostPlatform = "x86_64-linux";

}
