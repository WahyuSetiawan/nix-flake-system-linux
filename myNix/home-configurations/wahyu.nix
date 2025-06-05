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
  home = {
    username = primaryUser.username or user.username;
    stateVersion = "22.05";
    homeDirectory = (
      if pkgs.stdenv.isDarwin then
        "/Users/${user.username}" else
        "/home/${user.username}"
    );

    user-info = primaryUser;
  };



}
