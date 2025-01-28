{ inputs, pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true;
    xwayland.enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "gtk2";
  };

  environment.systemPackages = [
    pkgs.waybar
    pkgs.eww

    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))

    pkgs.dunst
    # nixpkgs.libnotify

    # nixpkgs.hyprpaper
    # nixpkgs.swaybg
    # nixpkgs.wpaperd
    # nixpkgs.wpvpaper
    # nixpkgs.swww

    # pkgs.rofy-wayland
    pkgs.wofi
    pkgs.bemenu
    pkgs.fuzzel
    pkgs.tofi


    pkgs.xkeyboard_config
    # pkgs.xorg.xinit
  ];


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  hardware = {
    opengl.enable = true;

    nvidia.modesetting.enable = true;
  };
}
