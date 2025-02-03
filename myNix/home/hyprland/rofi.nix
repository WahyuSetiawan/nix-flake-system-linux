{ pkgs, config, lib, ... }:
let
  hyprlandEnable = config.home.user-info.within.hyprland.enable;
  theme = config.home.user-info.within.hyprland.theme;
in
{
  config = lib.mkIf hyprlandEnable {
    home.file.".config/rofi".source = pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "rofi";
        rev = "main";
        hash = "sha256-zA8Zum19pDTgn0KdQ0gD2kqCOXK4OCHBidFpGwrJOqg=";
      } + "/deathemonic";
  };
}
