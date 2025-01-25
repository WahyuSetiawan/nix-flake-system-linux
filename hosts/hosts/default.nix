{ self, inputs, withSystem, ... }:
let
  mkCommonConfiguration = params@{ system, stateVersion }: ({ pkgs, ... }: {
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
