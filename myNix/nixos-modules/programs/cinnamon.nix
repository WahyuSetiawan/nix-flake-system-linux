{ inputs, pkgs, config, lib, ... }:
let
  cinnamonEnable = config.users.primaryUser.within.cinnamon.enable;
in
{
  config = lib.mkIf cinnamonEnable
    {
      services.xserver = {
        enable = true;
        desktopManager.cinnamon.enable = true;
      };
    };
}
