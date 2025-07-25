all@{ pkgs, osConfig, inputs, self, lib, ... }:
let
  primaryUser = osConfig.users.primaryUser;
  allModules = builtins.attrNames osConfig.users;
  # debugMsg = builtins.trace "isi dari all parameter ${lib.concatStringsSep ", " allModules}" allModules;
in
{
  # home.activation.debugInfo = ''
  # echo "list dari ${toString debugMsg}"
  # '';
  home = {
    username = "juragankoding";
    stateVersion = "24.11";
    homeDirectory = "/home/juragankoding";

  };

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;
  # home-manager.backupFileExtension = "backup";
  # home-manager.extraSpecialArgs = { };
  #
  # home-manager.sharedModules =
  #   if pkgs.stdenv.isDarwin then [
  #     inputs.mac-app-util.homeManagerModules.default
  #   ] else [ ];

  home.user-info = rec{
    username = "juragankoding";
    fullName = "Juragan Koding";
    email = "wahyu.creator911@gmail.com";
    pathHome = "home";
    nixConfigDirectory = "/home/${username}/.nix";
    within = {
      # hyprland.enable = true;
      # cinnamon.enable = true;
    };
  };


  # extraSpecialArgs = {
  #   inherit (inputs) nixgl;
  # };


  # extraSpecialArgs = {
  #         nixgl = inputs.nixgl;
  #       };

  # home-manager.users.juragankoding = {
  # imports = builtins.attrValues self.homeManagerModules
  # ++ [

  # ];

  # home.username = "juragankoding";
  # home.homeDirectory = "/home/juragankoding/.nix";

  # home.stateVersion = homeStateVersion;
  # programs.home-manager.enable = true;

  # };
}
