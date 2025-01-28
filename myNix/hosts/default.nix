{ self, inputs, withSystem, ... }:
let
  mkHomeConfiguration = import ./home-configuration.nix;
  mkCommonConfiguration = import ./common-configurations.nix;

  mkDarwinSystem = hostname: { system ? "aarch64-darwin"
                             , stateVersion ? 4
                             , homeStateVersion ? "24.11"
                             }: withSystem system ({ pkgs, config, ... }: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
      inherit self;
    };

    modules = builtins.attrValues self.commonModules
      ++ builtins.attrValues self.darwinModules
      ++ [
      inputs.home-manager.darwinModules.home-manager
      (mkCommonConfiguration { system = system; stateVersion = stateVersion; })
      (mkHomeConfiguration {
        user = "wahyu";
        pathHome = "Users";
        homeStateVersion = homeStateVersion;
      })
      ({ pkgs, ... }: {
        users.users.${"wahyu"} = {
          home = "/Users/wahyu";
        };
        system.configurationRevision = self.rev or self.dirtyRev or null;
      })
    ];
  }
  );

  mkNixosSystem = hostname: { system ? "x86_64-linux"
                            , stateVersion ? "24.11"
                            , homeStateVersion ? "24.11"
                            }: withSystem system ({ pkgs, config, ... }@ctx: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit self;
    };

    system = system;

    modules =
      builtins.attrValues self.commonModules
      ++ builtins.attrValues self.nixosModules
      ++ [
        inputs.home-manager.nixosModules.home-manager

        (mkCommonConfiguration { system = system; stateVersion = stateVersion; })
        (mkHomeConfiguration {
          user = "juragankoding";
          homeStateVersion = homeStateVersion;
        })

        (
          { inputs, config, pkgs, lib, ... }:
          {
            nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];
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

  mkDarwinConfiguration = configuration: builtins.mapAttrs mkDarwinSystem configuration;
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
