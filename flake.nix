{
  description = "Konfigurasi NixOS saya";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    cachix.url = "github:cachix/cachix";

    ### home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oxalica-nil = {
      url = "github:oxalica/nil";
    };
    ### -- nix related tools
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";

    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";

    # util for linux only
    hyprland.url = "github:hyprwm/Hyprland";

    # util for macbbook user
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };


    mac-app-util.url = "github:hraban/mac-app-util";

    sketchybar-app-font = {
      url = "github:kvndrsslr/sketchybar-app-font";
      flake = false;
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [
          inputs.process-compose-flake.flakeModule
          inputs.ez-configs.flakeModule
          ./myNix
        ];
      };
}
