{
  description = "Konfigurasi NixOS saya";

  inputs = {
    # Gunakan nixpkgs stabil
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Tambahkan input lain yang diperlukan
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

        perSystem = { config, self', inputs', pkgs, system, ... }: {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          # packages.default = pkgs.hello;
        };

        flake = {
          nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs; };
              system = "x86_64-linux"; # Sesuaikan dengan arsitektur sistem
              modules = [
                ./hardware-configuration.nix
                # Impor konfigurasi sistem yang ada
                ./configuration.nix
                # Tambahkan modul tambahan di sini
              ];
            };

          };
        };
      };
}
