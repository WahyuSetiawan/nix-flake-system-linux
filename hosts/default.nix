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

    darwinConfigurations = {
      "JuraganKoding-2" = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };

        modules = builtins.attrValues self.commonModules
          ++ builtins.attrValues self.darwinModules
          ++ [
          inputs.home-manager.darwinModules.home-manager
          ({ pkgs, ... }: {

            # imports = [
            #       ./modules/packages.nix
            #       ./modules/services/zsh.nix
            #     ];
            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 5;


            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";

            # programs.home-manager.enable = true;
          })
        ];
      };
    };
  };




}
