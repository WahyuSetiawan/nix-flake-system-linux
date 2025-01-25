{ self, inputs, withSystem, ... }:
let
  mkHomeConfiguration = import ./home-configuration.nix;
  mkCommonConfiguration = params@{ system, stateVersion }: ({ self, pkgs, ... }: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.hostPlatform = system;
    system.stateVersion = stateVersion;
  });

  mkDarwinSystem =
    hostname:
    { system ? "aarch64-darwin"
    , stateVersion ? 4
    ,
    }: withSystem system (
      { pkgs, config, ... }: inputs.nix-darwin.lib.darwinSystem {
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
in
{
  flake = {
    darwinConfigurations = mkDarwinConfiguration {
      "JuraganKoding-2" = { };
    };
  };



}
