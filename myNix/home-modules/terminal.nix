{ pkgs, config, lib, ... }:
let
  theme = config.home.user-info.within.hyprland.theme;
in
{
  home.file." ~/.config/alacritty/catppuccin-${theme}.toml".source = pkgs.fetchFromGitHub
    {
      owner = "catppuccin";
      repo = "alacritty";
      rev = "main";
      hash = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q=";
    } + "catppuccin-${theme}.toml";

  programs = {
    alacritty = {
      enable = false;
      settings = {
        general.import = [
          "~/.config/alacritty/catppuccin-${theme}.toml"
        ];
        window = {
          opacity = 0.8;
          startup_mode = "Windowed";
          title = "Juragan Koding";
          blur = true;
          padding = { x = 5; y = 5; };
          option_as_alt = "Both";
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
      } // lib.mkOptionattrs (pkgs.stdenv.isLinux) {
        package = config.lib.nixGL.wrap pkgs.alacritty;
      };
    };

    kitty = {
      enable = true;
      themeFile = "Catppuccin-Latte";
      extraConfig = #sh
        ''
          font_family JetBrainsMono Nerd Font
          font_size 8.0
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

          background_blur 5
          dynamic_background_opacity true

          # mac tweak
          macos_option_as_alt true

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
