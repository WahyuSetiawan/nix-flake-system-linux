{ config, pkgs, ... }: {
  services = {
    xserver.enable = true;

    xserver.displayManager.lightdm.enable = true;
    xserver.desktopManager.plasma5.enable = true;

    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

}
