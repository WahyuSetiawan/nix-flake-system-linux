{ pkgs, ... }: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.8;
          startup_mode = "Windowed";
          title = "Juragan Koding";
          blur = true;
          padding = { x = 5; y = 5; };
        };
        font = {
          size = 8;
          normal = {
            family =
              if pkgs.stdenv.isDarwin then
                "MesloLGLDZ Nerd Font"
              else
                "MesloLGLDZNerdFont";
            style = "Regular";
          };
        };
      };
    };

    kitty = {
      enable = true;
      themeFile = "Catppuccin-Latte";
      extraConfig = #sh
        ''
          font_family Fira Code SemiBold
          font_size 10.0
          bold_font auto
          italic_font auto
          bold_italic_font auto

          background_opacity 0.9
          dynamic_background_opacity 0.9

          confirm_os_window_close 0

          # change to x11 or wayland or leave auto
          linux_display_server auto

          scrollback_lines 2000
          wheel_scroll_min_lines 1

          enable_audio_bell no

          window_padding_width 4

          selection_foreground none
          selection_background none

          foreground #dddddd
          background #000000
          cursor #dddddd

          include ~/.config/kitty/kitty.conf
        '';
    };

    # ghostty = {
    #   enable = true;
    # };
  };
}
