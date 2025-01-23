{ config, pkgs, ... }: {
  services = {

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;

    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the Deepin Desktop Environment.
    xserver.displayManager.lightdm.enable = true;
    xserver.desktopManager.deepin.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

}
