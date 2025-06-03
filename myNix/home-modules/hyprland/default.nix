{ lib, config, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprpaper.nix
    ./rofi.nix
    ./dunst.nix
  ];
}
