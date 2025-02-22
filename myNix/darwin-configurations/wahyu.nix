{ inputs, self, pkgs, ... }:
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
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

  mouseless.enable = true;

  # nixpkgs = removeAttrs ctx.nixpkgs [ "hostPlatform" ];
  # environment.systemPackages = ctx.basePackageFor pkgs;
  environment.variables = {
    DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer";
  };

  users.users.${user.username} = {
    home = "/${user.pathHome}/${user.username}";
    shell = pkgs.fish;
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = stateVersion;

  nixpkgs.config.allowUnfree = true;

}
