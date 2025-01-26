params@{ user, homeStateVersion ? "24.11", ... }: ({ self, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users = {
    ${user} = {
      imports = builtins.attrValues self.homeManagerModules
        ++ [
  
      ];

      home.username = user;
      home.homeDirectory = "/home/${user}";

      home.stateVersion = homeStateVersion;
      programs.home-manager.enable = true;
    };
  };
})
