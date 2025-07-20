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

    programs.waybar.enable = true;
    programs.xwayland.enable = true;
    # programs.sway.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORMTHEME = "gtk2";
    };

    environment.systemPackages = with pkgs; [
      # GTK theme engines and tools
      gtk3
      gtk4
      glib
      gsettings-desktop-schemas

      # Popular GTK themes
      adwaita-icon-theme
      gnome-themes-extra
      arc-theme
      numix-icon-theme
      papirus-icon-theme

      # Theme management tools
      lxappearance
      nwg-look # GTK theme manager for Wayland

      # Font packages
      noto-fonts
      # noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf

      # Optional: Additional popular themes
      materia-theme
      nordic
      orchis-theme

      hyprland
      eww

      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))

      # dunst
      hyprshot
      # nixpkgs.libnotify

      hyprpaper
      # nixpkgs.swaybg
      # nixpkgs.wpaperd
      # nixpkgs.wpvpaper
      # nixpkgs.swww

      # pkgs.rofy-wayland
      rofi-wayland
      xdg-user-dirs
      viewnior

      iw
      firefox-wayland
      wofi
      pkgs.bemenu
      pkgs.fuzzel
      pkgs.tofi

      swaylock
      wlogout


      xkeyboard_config
      # pkgs.xorg.xinit

      # image viewer
      swayimg
      # file manager
      # dolphin
      nautilus
    ];


    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };
  };
}
