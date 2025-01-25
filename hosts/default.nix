{ inputs, ... }: {
  flake = {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux"; # Sesuaikan dengan arsitektur sistem
        modules = [
          ./hardware
          ./configuration.nix
        ];
      };

    };
  };

}
