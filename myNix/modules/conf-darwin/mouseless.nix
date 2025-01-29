{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mdDoc
    mkOption
    types
    mkIf;

  cfg = config.mouseless;

in
{

  option.mouseless.enable = mkEnableOption (mdDoc "enable mode mouseless");

  option.mouseless.wm = mkOption {
    type = types.enum [
      "none"
      "aerospace"
    ];
    default = "aerospace";
  };
  config = mkIf cfg.mouseless.enable {

    services.aerospace = {
      enable = cfg.wm == "aerospace";
      settings = {
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "${lib.getExe pkgs.sketchybar} --trigger space_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        gaps = {
          outer.top = 50;
          outer.bottom = 15;
          outer.left = 15;
          outer.right = 15;
          inner.horizontal = 15;
          inner.vertical = 15;
        };
        mode.main.binding = {
          alt-space = "layout floating";
          alt-z = "resize smart +10";
          alt-shift-z = "resize smart -10";
          alt-v = "layout v_tiles";
          alt-shift-v = "layout h_tiles";
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-f = "fullscreen";
          alt-shift-space = "balance-sizes";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
        };
      };
    };

  };
}
