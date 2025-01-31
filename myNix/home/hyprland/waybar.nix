{ pkgs, lib, config, ... }:
let
  hyprlandEnable = config.home.user-info.within.hyprland.enable;
in
rec {
  config = lib.mkIf hyprlandEnable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "DP-1"
          ];
          modules-left = [ "hyprland/workspaces" "sway/mode" "wlr/taskbar" ];
          modules-center = [ "hyprland/window" "custom/hello-from-waybar" ];
          modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
          "custom/hello-from-waybar" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
          };
        };
      };

      style = #css
        ''
          @import "styles.css";

          * {
            color: @text;
            border: none;
            border-radius: 0;
            font-family: Source Code Pro;
          }
          window#waybar {
            background: #16191C;
            color: #AAB2BF;
          }
          #workspaces button {
            padding: 0 5px;
          }
        '';
    };

    home.file.".config/waybar/styles.css".source = pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "waybar";
        rev = "main";
        hash = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
      } + "/themes/mocha.css";
  };

}
