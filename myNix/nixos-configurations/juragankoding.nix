{ ezModules, config, inputs, pkgs, ... }:
{
  imports = [
    # inputs.home-manager.nixosModules.home-manager
    ezModules.hardware
    ezModules.user
  ];

  # inherit (ctx) nix;
  users.primaryUser = rec{
    username = "juragankoding";
    fullName = "Juragan Koding";
    email = "wahyu.creator911@gmail.com";
    pathHome = "home";
    nixConfigDirectory = "/home/${username}/.nix";
    within = {
      hyprland.enable = true;
    };
  };

  # nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];

  users.users."juragankoding" = {
    isNormalUser = true;
    description = "Juragan Koding";
    extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];

    shell = pkgs.fish;
  };

  # nixpkgs.hostPlatform = "x86_64-linux";

  # nix.settings.experimental-features = [
  #   "nix-command"
  #   "flakes"
  # ];

  # nixpkgs.hostPlatform = system;
  system.stateVersion = "24.11";

  # nixpkgs.config.allowUnfree = true;
}
