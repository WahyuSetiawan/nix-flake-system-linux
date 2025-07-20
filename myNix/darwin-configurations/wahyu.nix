{ lib, inputs, pkgs, ... }:
let
  user = rec{
    username = "wahyu";
    fullName = "wahyu setiawan";
    email = "wahyu.creator911@gmail.com";
    pathHome = "Users";
    nixConfigDirectory = "/Users/${username}/.nix";
  };
  stateVersion = 4;
in
{
  imports = lib.lists.concatLists [
    (builtins.attrValues inputs.self.crossModules)
  ] ++ [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  mouseless.enable = true;

  system.primaryUser = "wahyu";
  ids.gids.nixbld = 350;

  users.primaryUser = {
    username = user.username;
    fullName = user.fullName;
    email = user.email;
    pathHome = "Users";
    nixConfigDirectory = user.nixConfigDirectory;
  };


  # nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];
  # environment.systemPackages = ctx.basePackageFor pkgs;
  environment.variables = {
    DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer";
  };

  users.users.${user.username} = {
    home = "/${user.pathHome}/${user.username}";
    shell = pkgs.fish;
  };

  # users.extraGroups.docker.members = [ "username-with-access-to-socket" ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = stateVersion;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

}
