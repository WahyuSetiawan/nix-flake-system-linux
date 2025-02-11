{ config, lib, pkgs, ... }:
let

  hyprlandEnable = config.home.user-info.within.hyprland.enable;
  directory = "Pictures";
in
{
  config = lib.mkIf hyprlandEnable {
    home.file."${directory}/wallpaper.png".source = ./wallpaper.png;

    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      preload = [
        "~/${directory}/wallpaper.png"
      ];
      wallpaper = [
        "HDMI-A-1,~/${directory}/wallpaper.png"
        "DP-1,~/${directory}/wallpaper.png"
      ];
    };
  };
}
