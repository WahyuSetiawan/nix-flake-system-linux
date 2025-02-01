{ inputs, pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mdDoc;
  hostname = pkgs.stdenv.hostPlatform.system;
  # hyprlandEnable = true;
  hyprlandEnable = config.users.primaryUser.within.hyprland.enable;
in
{
  config = lib.mkIf hyprlandEnable {
    programs.hyprland = {
      enable = true;
      # nvidiaPatches = true;
      xwayland.enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${hostname}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${hostname}.xdg-desktop-portal-hyprland;
    };

    programs.waybar = {
      enable = true;
    };

    programs.xwayland.enable = true;
    # programs.sway.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORMTHEME = "gtk2";
    };

    environment.systemPackages = with pkgs; [
      hyprland
      eww

      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))

      dunst
      # nixpkgs.libnotify

      hyprpaper
      # nixpkgs.swaybg
      # nixpkgs.wpaperd
      # nixpkgs.wpvpaper
      # nixpkgs.swww

      # pkgs.rofy-wayland
      rofi-wayland
      firefox-wayland
      wofi
      pkgs.bemenu
      pkgs.fuzzel
      pkgs.tofi

      swaylock
      wlogout


      xkeyboard_config
      # pkgs.xorg.xinit
    ];


    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    hardware = {
      opengl.enable = true;

      nvidia.modesetting.enable = true;
    };
  };
}
