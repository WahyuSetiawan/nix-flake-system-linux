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
                             , user ? self.users.default
                             }: withSystem system ({ pkgs, config, ... }@ctx: inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self homeStateVersion; };

    modules =
      concatLists [
        commonModules
        darwinModules
        [
          inputs.mac-app-util.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          (mkCommonConfiguration { inherit system stateVersion; })
          (mkHomeConfiguration { inherit user homeStateVersion; })
        ]
      ]
      ++ [
        ({ pkgs, ... }: {
          inherit (ctx) nix;
          mouseless.enable = true;

          nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];
          environment.systemPackages = ctx.basePackageFor pkgs;
          environment.variables = {
            DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer";
          };

          users.users.${user.username} = {
            home = "/${user.pathHome}/${user.username}";
            shell = pkgs.fish;
          };
          system.configurationRevision = self.rev or self.dirtyRev or null;
        })
      ];
  });

  mkNixosSystem = hostname: { system ? "x86_64-linux"
                            , stateVersion ? "24.11"
                            , homeStateVersion ? "24.11"
                            , user ? self.users.default
                            }: withSystem system ({ pkgs, config, ... }@ctx: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };

    system = system;

    modules = concatLists [
      commonModules
      nixosModules
      [
        inputs.home-manager.nixosModules.home-manager
        (mkCommonConfiguration { inherit system stateVersion; })
        (mkHomeConfiguration { inherit user homeStateVersion; })
      ]
    ]
    ++ [
      ({ inputs, config, pkgs, lib, ... }:
        {
          inherit (ctx) nix;
          users.primaryUser = user;

          nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];

          users.users.${user.username} = {
            isNormalUser = true;
            description = user.fullName;
            extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" ];

            shell = pkgs.fish;
          };

        }
      )
    ];
  });

  mkDarwinConfiguration = configuration: builtins.mapAttrs mkDarwinSystem configuration;
  mkNixosConfigurations = configuration: builtins.mapAttrs mkNixosSystem configuration;
in
{
  flake.users = {
    default = rec{
      username = "juragankoding";
      fullName = "Juragan Koding";
      email = "wahyu.creator911@gmail.com";
      pathHome = "home";
      nixConfigDirectory = "/home/${username}/.nix";
      within = {
        hyprland.enable = true;
      };
    };
  };

  flake = {
    darwinConfigurations = mkDarwinConfiguration {
      default = {
        user = rec{
          username = "wahyu";
          fullName = "wahyu setiawan";
          email = "wahyu.creator911@gmail.com";
          pathHome = "Users";
          nixConfigDirectory = "/Users/${username}/.nix";
        };
      };

    };

    nixosConfigurations = mkNixosConfigurations {
      nixos = { };
      default = { };
    };
  };
}
