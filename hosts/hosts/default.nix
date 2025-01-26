{ self, inputs, withSystem, ... }:
let
  mkHomeConfiguration = import ./home-configuration.nix;
  mkCommonConfiguration = import ./common-configurations.nix;

  mkDarwinSystem = hostname: { system ? "aarch64-darwin"
                             , stateVersion ? 4
                             ,
                             }: withSystem system ({ pkgs, config, ... }: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };

    modules = builtins.attrValues self.commonModules
      ++ builtins.attrValues self.darwinModules
      ++ [
      inputs.home-manager.darwinModules.home-manager
      (mkCommonConfiguration { system = system; stateVersion = stateVersion; })
      # (mkHomeConfiguration { user = "wahyu"; })
      ({ pkgs, ... }: {
        system.configurationRevision = self.rev or self.dirtyRev or null;

      })
    ];
  }
  );

  mkDarwinConfiguration = configuration: builtins.mapAttrs mkDarwinSystem configuration;


  mkNixosSystem = hostname: params@{ system ? "x86_64-linux"
                            , stateVersion ? "24.11"
                            }: withSystem system ({ pkgs, config, ... }: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };

    system = system;

    modules =
      builtins.attrValues self.commonModules
      ++ builtins.attrValues self.nixosModules
      ++ [
        inputs.home-manager.nixosModules.home-manager
        (mkCommonConfiguration { system = system; stateVersion = stateVersion; })
        (
          { inputs, config, pkgs, lib, ... }:
          {
            users.defaultUserShell = pkgs.zsh;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            users.users.juragankoding = {
              isNormalUser = true;
              description = "Juragan Koding";
              extraGroups = [ "networkmanager" "wheel" ];
              packages = with pkgs; [
                #  thunderbird
              ];
            };

          }



        )
      ];
  });

  mkNixosConfigurations = configuration: builtins.mapAttrs mkNixosSystem configuration;
in
{
  flake = {
    darwinConfigurations = mkDarwinConfiguration {
      "JuraganKoding-2" = { };
    };

    nixosConfigurations = mkNixosConfigurations {
      nixos = { };
    };
  };
}
