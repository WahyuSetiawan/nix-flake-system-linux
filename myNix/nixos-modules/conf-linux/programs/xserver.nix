{ config, pkgs, ... }: {
  services = {
    xserver.enable = true;

    xserver = {
      displayManager = {
        lightdm.enable = false;
        gdm.enable = true;
      };

      desktopManager.plasma5.enable = false;
    };


    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

}
