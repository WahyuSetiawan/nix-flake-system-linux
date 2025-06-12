{ pkgs, lib, config, ... }:
let
  hyprlandEnable = config.home.user-info.within.hyprland.enable;
in
{
  config = lib.mkIf hyprlandEnable
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            browser = "${config.programs.firefox.package}/bin/firefox -new-tab";
            dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
            follow = "mouse";
            font = "Droid Sans 10";
            format = "<b>%s</b>\\n%b";
            frame_width = 2;
            geometry = "500x5-5+30";
            horizontal_padding = 8;
            icon_position = "off";
            line_height = 0;
            markup = "full";
            padding = 8;
            separator_height = 2;
            transparency = 10;
            word_wrap = true;

            frame_color = "#8aadf4";
            separator_color = "frame";
            highlight = "#8aadf4";

          };

          urgency_low = {
            background = "#24273a";
            foreground = "#cad3f5";
            frame_color = "#4da1af";
            timeout = 10;
          };

          urgency_normal = {
            background = "#24273a";
            foreground = "#cad3f5";
            frame_color = "#70a040";
            timeout = 15;
          };

          urgency_critical = {
            background = "#24273a";
            foreground = "#cad3f5";
            frame_color = "#f5a97f";

            timeout = 0;
          };

          shortcuts = {
            context = "mod4+grave";
            close = "mod4+shift+space";
          };
        };
      };
    };
}
