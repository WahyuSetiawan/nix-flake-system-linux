{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mdDoc mkIf;
  cfg = config.mouseless;
in
{
  options.mouseless.enable = mkEnableOption (mdDoc "enable mode mouseless");

  config = mkIf cfg.enable {
    # Mouseless configuration is now empty
    # All sketchybar and aerospace configurations have been removed
  };
}


