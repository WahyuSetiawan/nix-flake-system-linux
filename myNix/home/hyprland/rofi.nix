{ pkgs, config, lib, ... }:
let
  hyprlandEnable = config.home.user-info.within.hyprland.enable;
  theme = "mocha";
in
{
  config = lib.mkIf hyprlandEnable {
    home.file.".config/rofi".source = pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "rofi";
        rev = "main";
        hash = "";
      } + "/deathemonic";
  };
}
