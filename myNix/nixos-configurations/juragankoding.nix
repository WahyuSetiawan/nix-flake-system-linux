all@{ ezModules, config, inputs, pkgs, lib, nixpkgs, ... }:
let
  selfOverlays = lib.attrValues inputs.self.overlays;
  overlays = [ ] ++ selfOverlays;
  allModules = builtins.attrNames all.options.system;
  debug = builtins.trace "isi dari system ${lib.concatStringsSep ", " allModules}" allModules;
  debugMsg = builtins.trace "Debug: config.time.timeZone = ${config.time.timeZone}" config.time.timeZone;
in
{
  # skjystem.activationScripts.debug = ''
  #   echo "List: ${toString debug}"
  # '';

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
    nixConfigDirectory = "/home/${ username}/.nix";
    within = {
      hyprland. enable = true;
    };
  };

  users.users."juragankoding" = {
    isNormalUser = true;
    description = "Juragan Koding";
    extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];

    shell = pkgs.fish;
  };

  system.stateVersion = "24.11";

  nix.settings.trusted-users = [ "root" "juragankoding" ];
    nixpkgs.hostPlatform = "aarch64-darwin";

}
