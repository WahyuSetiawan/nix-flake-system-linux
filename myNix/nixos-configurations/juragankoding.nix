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

  imports = [
    ezModules.hardware
    ezModules.system
    ezModules.user
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

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config = {
      lib.mkForce = {
        allowBroken = true;
        allowUnfree = true;
        tarball-ttl = 0;

        contentAddressedByDefault = false;

      };
      android_sdk.accept_license = true;
      allowUnfree = true;

      substituters = [
        "https://juragankoding-cachix.cachix.org" # Ganti dengan nama cache Anda
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "juragankoding-cachix.cachix.org-1:ex3UA6Mt3+flrMkn9QmtX3iv2YowKXz8704acL2uPrY=" # Ganti dengan public key Anda
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    hostPlatform = "x86_64-linux";
    inherit overlays;
  };

  nix.settings.trusted-users = [ "root" "juragankoding" ];
}
