{ pkgs, osConfig, inputs, self, ... }:
{
  home = {
    username = "juragankoding";
    stateVersion = "24.11";
    homeDirectory = "/home/juragankoding";
  };

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  # home-manager.backupFileExtension = "backup";
  # home-manager.extraSpecialArgs = { };

  # home-manager.sharedModules =
  # if pkgs.stdenv.isDarwin then [
  # inputs.mac-app-util.homeManagerModules.default
  # ] else [ ];

  # home-manager.users.juragankoding = {
  #   # imports = builtins.attrValues self.homeManagerModules
  #   # ++ [
  #
  #   # ];
  #
  #   home.username = "juragankoding";
  #   home.user-info = "juragankoding";
  #   home.homeDirectory = "/home/juragankoding/.nix";
  #
  #   # home.stateVersion = homeStateVersion;
  #   # programs.home-manager.enable = true;
  #
  # };
}
