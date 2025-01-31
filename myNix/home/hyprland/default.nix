{ lib, config, ... }:
let
  hyprlandEnable = config.home.user-info.within.hyprland.enable;
in
{
  imports =
    if hyprlandEnable then [
      ./hyprland.nix
      ./waybar.nix
    ] else [ ];
}
