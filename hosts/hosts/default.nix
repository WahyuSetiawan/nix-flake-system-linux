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
    hostname: params@{ system ? "aarch64-darwin"
              , stateVersion ? 4
              ,
              }: withSystem system (
      { pkgs, config, ... }: inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs params; };

        modules = [
        ] ++ builtins.attrValues self.commonModules
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
    # nixosConfigurations = {
    #   nixos = inputs.nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs;
    #     };
    #
    #     system = "x86_64-linux";
    #
    #     modules =
    #       builtins.attrValues self.commonModules
    #       ++ builtins.attrValues self.nixosModules
    #       ++ [
    #         inputs.home-manager.nixosModules.home-manager
    #         ./hardware
    #         ./configuration.nix
    #       ];
    #   };
    # };

    darwinConfigurations = mkDarwinConfiguration {
      "JuraganKoding-2" = { };
    };
  };



}
