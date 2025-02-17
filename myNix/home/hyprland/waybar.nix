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
          default = {
            font = "JetBrainsMono Nerd Font 10";
          };
          layer = "top";
          position = "top";
          height = 20;
          output = [
            "DP-1"
          ];
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "hyprland/window"
            # "custom/hello-from-waybar"
          ];
          modules-right = [
            "cpu"
            "memory"
            "bluetooth"
            "network"
            "mpd"
            "temperature"
            "clock"
            "tray"
            "custom/lock"
            "custom/power"
          ];

          "tray" = {
            "icon-size" = 21;
            "spacing" = 10;
          };

          "hyprland/workspaces" = {
            "sort-by-name" = true;
            "format" = "<sub>{icon}</sub>{windows}";
            "window-rewrite-default" = "";
            "format-icons" = {
              "active" = "";
              "default" = "󰮯";
            };
            disable-scroll = true;
            all-outputs = true;
          };

          "clock" = {
            "timezone" = "Asia/Jakarta";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "󰥔 {:%d/%m/%Y}";
            "format" = "󰥔 {:%H:%M}";
          };

          "custom/hello-from-waybar" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
          };

          "custom/lock" = {
            "tooltip" = false;
            "on-click" = "sh -c '(sleep 0.5s; swaylock --grace 0)' & disown";
            "format" = "";
          };

          "custom/power" = {
            "tooltip" = false;
            "on-click" = "~/.config/rofi/bin/powermenu &";
            "format" = "󰐥";
          };

          "cpu" = {
            "interval" = 1;
            "format" = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
            "format-icons" = [
              "<span color='#69ff94'>▁</span>"
              "<span color='#2aa9ff'>▂</span>"
              "<span color='#f8f8f2'>▃</span>"
              "<span color='#f8f8f2'>▄</span>"
              "<span color='#ffffa5'>▅</span>"
              "<span color='#ffffa5'>▆</span>"
              "<span color='#ff9977'>▇</span>"
              "<span color='#dd532e'>█</span>"
            ];
          };

          "memory" = {
            "interval" = 30;
            "format" = "{used:0.1f}G/{total:0.1f}G ";
          };

          "network" = {
            # "interface" = "wlp2s0";
            "format" = "{ifname}";
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} 󰊗";
            "format-disconnected" = "";
            "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
            "tooltip-format-ethernet" = "{ifname} ";
            "tooltip-format-disconnected" = "Disconnected";
            "max-length" = 50;
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
            font-family: JetBrainsMono Nerd Font;
            font-size: 9px;
          }

          window > box {
            margin-left: 5px;
            margin-right: 5px;
            margin-top: 5px;
            background-color: shade(@base, 0.9);
            border: 2px solid alpha(@crust, 0.3);
            border-radius: 30px; /* Membuat sudut melengkung */
          }

          window#waybar {
            padding: 10px;
            margin-top: 10px; /* Margin atas */
            margin-left: 10px; /* Margin kiri */
            margin-right: 10px; /* Margin kanan */
          }

          window#waybar.hidden{
            opacity: 0.2;
          }

          #workspaces {
            border-radius: 1rem;
            margin: 5px;
            background-color: @surface0;
            margin-left: 1rem;
          }

          #workspaces button {
            color: @lavender;
            border-radius: 1rem;
            padding: 0.2rem;
          }

          #workspaces button.empty {
            color: @overlay0;
          }

          #workspaces button.visible {
            color: @blue;
          }

          #workspaces button.active{
            color: @green;
          }

          #custom-music,
          #tray,
          #cpu,
          #memory,
          #backlight,
          #clock,
          #bluetooth,
          #network,
          #battery,
          #pulseaudio,
          #temperature,
          #custom-lock,
          #custom-power {
                background-color: @surface0;
                padding: 0.5rem 1rem;
                margin: 2px 0;
          }

          #clock {
            color: @blue;
            border-radius: 0px 1rem 1rem 0px;
            margin-right: 1rem;
          }

          #cpu {
            color: @green;
            border-radius: 1rem 0rem 0rem 1rem;
            margin-left: 1rem;
          }

          #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
          }
          
          #custom-power {
              margin-right: 1rem;
              border-radius: 0px 1rem 1rem 0px;
              color: @red;
          }
          
          #tray {
            margin-right: 1rem;
            border-radius: 1rem;
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
