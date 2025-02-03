{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mdDoc
    mkOption
    types
    mkIf;

  cfg = config.mouseless;

  lua = pkgs.lua54Packages.lua.withPackages (ps: [
    # ps.lua
    # pkgs.sbarLua
    # pkgs.sketchybarConfigLua
  ]);
in
{
  options.mouseless.enable = mkEnableOption (mdDoc "enable mode mouseless");

  options.mouseless.wm = mkOption {
    type = types.enum [
      "none"
      "aerospace"
    ];
    default = "aerospace";
  };

  config = mkIf cfg.enable {
    services.sketchybar = {
      enable = cfg.enable;
      # package = branches.master.sketchybar;
      extraPackages = with pkgs; [
        # sbar_menus
        # sbar_events
      ];

      config = # lua
        ''
          #!${lua}/bin/lua
          package.cpath = package.cpath .. ";${lua}/lib/?.so"
          require("init")
        '';
    };

    services.aerospace = {
      enable = cfg.wm == "aerospace";
      settings = {
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "${lib.getExe pkgs.sketchybar} --trigger space_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        gaps = {
          outer.top = 40;
          outer.bottom = 12;
          outer.left = 12;
          outer.right = 12;
          inner.horizontal = 12;
          inner.vertical = 12;
        };
        on-window-detected = [
          {
            check-further-callbacks = false;
            ${"if"} = {
              app-id = "com.apple.iphonesimulator";
            };
            run = [
              "layout floating"
            ];
          }
          {
            check-further-callbacks = false;
            ${"if"} = {
              app-id = "ru.keepcoder.Telegram";
            };
            run = [
              "move-node-to-workspace 2"
            ];
          }
          {
            check-further-callbacks = false;
            ${"if"} = {
              app-id = "net.whatsapp.WhatsApp";
            };
            run = [

              "move-node-to-workspace 2"
            ];
          }



        ];
        mode.main.binding = {
          alt-enter = #sh
            ''
              exec-and-forget osascript -e '
              do shell script "open -n -a Alacritty"
              '
            '';
          alt-space = "layout floating tiling";

          alt-z = "resize smart +10";
          alt-shift-z = "resize smart -10";
          alt-v = "layout v_tiles";
          alt-shift-v = "layout h_tiles";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-f = "fullscreen";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

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

    services.jankyborders = {
      # package = branches.master.jankyborders;
      enable = cfg.enable;
      width = 6.5;
      hidpi = false;
      active_color = "0xfffeeff0";
      inactive_color = "0xc02c2e34";
      background_color = "0x302c2e34";
      style = "round";
    };
  };
}


