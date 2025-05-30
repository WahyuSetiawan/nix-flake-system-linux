# This is the module that will be imported with the `homeManagerConfigurations.example-user@<system>` configuration
# You can use `ezModules` as a shorthand for accesing your flake's `homeConfigurations`
{ pkgs, ezModules, osConfig, self, lib, ... }:

let
  primaryUser = osConfig.users.primaryUser;
  user = rec{
    username = "wahyu";
    fullName = "wahyu setiawan";
    email = "wahyu.creator911@gmail.com";
    pathHome = "Users";
    nixConfigDirectory = "/Users/${username}/.nix";
  };
in
{
  # imports = [
  #   ezModules.direnv
  #   ({ self, lib, ... }:
  #     let
  #       inherit (lib) mkOption types;
  #     in
  #     {
  #       options = {
  #         home.user-info = {
  #           username = mkOption {
  #             type = with types; nullOr str;
  #             default = null;
  #           };
  #           fullName = mkOption {
  #             type = with types; nullOr str;
  #             default = null;
  #           };
  #           email = mkOption {
  #             type = with types; nullOr str;
  #             default = null;
  #           };
  #           nixConfigDirectory = mkOption {
  #             type = with types; nullOr str;
  #             default = null;
  #           };
  #           pathHome = mkOption {
  #             type = with types; nullOr str;
  #             default = null;
  #           };
  #           within = {
  #             hyprland.enable = mkOption {
  #               type = with types; bool;
  #               default = false;
  #             };
  #             hyprland.theme = mkOption {
  #               type = types.enum [
  #                 "mocha"
  #                 "frappe"
  #                 "macchiato"
  #                 "latte"
  #               ];
  #               default = "mocha";
  #             };
  #             neovim.enable = mkOption {
  #               type = with types; bool;
  #               default = false;
  #             };
  #             gpg.enable = mkOption {
  #               type = with types; bool;
  #               default = false;
  #             };
  #             pass.enable = mkOption {
  #               type = with types; bool;
  #               default = false;
  #             };
  #           };
  #         };
  #       };
  #     }
  #   )
  #
  # ];
  #
  home = {
    username = osConfig.users.users.example-user.name or user;
    stateVersion = "22.05";
    homeDirectory = osConfig.users.users.example-user.home or (
      if pkgs.stdenv.isDarwin then
        "/Users/${user}" else
        "/home/${user}"
    );

    # user-info = {
    #   inherit user;
    # };
    user-info = primaryUser;
  };



}
