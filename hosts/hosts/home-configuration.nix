params@{ user, homeStateVersion ? "24.11", ... }: ({ pkgs, ... }: {
  home-manager.users."wahyu" = {
    home.username = "wahyu";
    home.homeDirectory = "/Users/wahyu";

    home.stateVersion = homeStateVersion;
    programs.home-manager.enable = true;
  };
})
