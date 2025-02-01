{ user, homeStateVersion ? "24.11", ... }: ({ inputs, self, pkgs, ... }:
  let
    username = user.username;
    pathHome = user.pathHome;
  in
  {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.extraSpecialArgs = { };

    home-manager.sharedModules =
      if pkgs.stdenv.isDarwin then [
        inputs.mac-app-util.homeManagerModules.default
      ] else [ ];

    home-manager.users.${username} = {
      imports = builtins.attrValues self.homeManagerModules
        ++ [

      ];

      home.username = username;
      home.user-info = user;
      home.homeDirectory = "/${pathHome}/${username}";

      home.stateVersion = homeStateVersion;
      programs.home-manager.enable = true;
    };
  })
