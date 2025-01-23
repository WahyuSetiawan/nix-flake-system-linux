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

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Ganti "hostname" dengan nama host sistem Anda
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
}
