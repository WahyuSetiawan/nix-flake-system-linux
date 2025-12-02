all@{ pkgs, osConfig ? null, inputs ? null, self ? null, lib, ... }:
let
  primaryUser = if osConfig != null then osConfig.users.primaryUser else null;
  allModules = if osConfig != null then builtins.attrNames osConfig.users else [];
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
