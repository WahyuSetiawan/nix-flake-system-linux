{ self, lib, inputs, withSystem, ... }:
let
  inherit (lib.lists) concatLists;
  commonModules = builtins.attrValues self.commonModules;
  nixosModules = builtins.attrValues self.nixosModules;
  darwinModules = builtins.attrValues self.darwinModules;

  mkHomeConfiguration = import ./home-configuration.nix;
  mkCommonConfiguration = import ./common-configurations.nix;

  mkDarwinSystem = hostname: { system ? "aarch64-darwin"
                             , stateVersion ? 4
                             , homeStateVersion ? "24.11"
                             }: withSystem system ({ pkgs, config, ... }@ctx: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self homeStateVersion; };

    modules =
      concatLists [
        commonModules
        darwinModules
        [
          inputs.mac-app-util.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
          (mkCommonConfiguration { inherit system stateVersion; })
          (mkHomeConfiguration { user = "wahyu"; pathHome = "Users"; inherit homeStateVersion; })
        ]
      ]
      ++ [
        ({ pkgs, ... }: {
          mouseless.enable = true;

          nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];
          environment.systemPackages = ctx.basePackageFor pkgs;

          users.users.${"wahyu"} = {
            home = "/Users/wahyu";
          };
          system.configurationRevision = self.rev or self.dirtyRev or null;
        })
      ];
  });

  mkNixosSystem = hostname: { system ? "x86_64-linux"
                            , stateVersion ? "24.11"
                            , homeStateVersion ? "24.11"
                            }: withSystem system ({ pkgs, config, ... }@ctx: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };

    system = system;

    modules = concatLists [
      commonModules
      nixosModules
      [
        inputs.home-manager.nixosModules.home-manager
        (mkCommonConfiguration { inherit system stateVersion; })
        (mkHomeConfiguration { user = "juragankoding"; inherit homeStateVersion; })
      ]
    ]
    ++ [
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
