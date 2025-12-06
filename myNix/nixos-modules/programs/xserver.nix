{ config, pkgs, ... }:
{
  services = {
    xserver.enable = true;

    xserver = {
      displayManager = {
        lightdm.enable = false;
        gdm.enable = true;
      };
    };

    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

}
