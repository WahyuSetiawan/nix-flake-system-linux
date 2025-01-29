{ user, pathHome ? "home", homeStateVersion ? "24.11", ... }: ({ inputs, self, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { };

  home-manager.sharedModules =
    if pkgs.stdenv.isDarwin then [
      inputs.mac-app-util.homeManagerModules.default
    ] else [ ];

  home-manager.users.${user} = {
    imports = builtins.attrValues self.homeManagerModules
      ++ [

    ];

    home.username = user;
    home.homeDirectory = "/${pathHome}/${user}";

    home.stateVersion = homeStateVersion;
    programs.home-manager.enable = true;
  };
})
