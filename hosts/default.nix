{ self, inputs, ... }: {
  imports = [
    ./modules
    ./home
    ./hosts
  ];

  perSystem = { lib, system, input', ... }: {
    _module.args = {
      nixpkgs = {
        config = lib.mkForce {
          allowBroken = true;
          allowUnfree = true;
          tarball-ttl = 0;
        };

        hostPlatform = system;
      };
    };
  };

  flake = {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };

        system = "x86_64-linux";

        modules =
          builtins.attrValues self.commonModules
          ++ builtins.attrValues self.nixosModules
          ++ [
            inputs.home-manager.nixosModules.home-manager
            ./hardware
            ./configuration.nix
          ];
      };
    };

    # darwinConfigurations = {
    #   "JuraganKoding-2" = inputs.nix-darwin.lib.darwinSystem {
    #     specialArgs = { inherit inputs; };
    #
    #     modules = builtins.attrValues self.commonModules
    #       ++ builtins.attrValues self.darwinModules
    #       ++ [
    #       inputs.home-manager.darwinModules.home-manager
    #       ({ pkgs, ... }: {
    #
    #         nix.settings.experimental-features = "nix-command flakes";
    #
    #         system.configurationRevision = self.rev or self.dirtyRev or null;
    #
    #         system.stateVersion = 5;
    #         nixpkgs.hostPlatform = "aarch64-darwin";
    #       })
    #     ];
    #   };
    # };
  };




}
