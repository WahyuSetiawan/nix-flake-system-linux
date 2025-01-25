{ self, inputs, ... }: {
  imports = [
    ./modules
  ];

  flake = {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        system = "x86_64-linux"; # Sesuaikan dengan arsitektur sistem
        modules =
          builtins.attrValues self.commonModules
          ++ builtins.attrValues self.nixosModules
          ++ [
            ./hardware
            ./configuration.nix
          ];
      };

    };
  };

}
