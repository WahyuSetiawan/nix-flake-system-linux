{
  description = "Konfigurasi NixOS saya";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ### home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### -- nix related tools
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";

    # android-nixpkgs = {
    #   url = "github:tadfisher/android-nixpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # util for linux only
    hyprland.url = "github:hyprwm/Hyprland";

    # util for macbbook user
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [
          inputs.process-compose-flake.flakeModule

          ./myNix
        ];
      };
}
