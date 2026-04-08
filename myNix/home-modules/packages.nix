{
  inputs,
  pkgs,
  config,
  lib,
  args,
  ...
}:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
  dirAllias = ./packages;
  listPackages = inputs.self.util.filesIntoList {
    inherit lib;
    dir = dirAllias;
    args = { inherit inputs pkgs config; };
  };
in
{
  # nixGL configuration - only for Linux
  nixGL = lib.mkIf pkgs.stdenv.isLinux {
    packages = import inputs.nixgl {
      inherit pkgs;
      enable32bits = false; # Add this to avoid some issues
    };
    defaultWrapper = "mesa"; # Change from nvidiaPrime to mesa for better compatibility
    offloadWrapper = "mesa";
    installScripts = [ "mesa" ]; # Remove nvidiaPrime for now
  };

  home.packages =
    with pkgs;
    listPackages
    ++ [
      # development
      killall
      xclip

      lua-language-server

      nodejs

      nixd
      nil
      # mcp server nix
      mcp-nixos
    ]
    ++ (
      if pkgs.stdenv.isLinux then
        [
          arandr
          wl-clipboard

          nerd-fonts.jetbrains-mono
          nerd-fonts.fira-code
          nerd-fonts.hack
          nerd-fonts.symbols-only
          nerd-fonts.meslo-lg
        ]
      else
        [ ]
    );

  fonts.fontconfig.enable = true;

  # Desktop entries for applications - only for Linux
  xdg.desktopEntries = lib.mkIf pkgs.stdenv.isLinux {
    postman = {
      name = "Postman";
      comment = "API Development Environment";
      exec = "postman";
      icon = "postman";
      terminal = false;
      type = "Application";
      categories = [
        "Development"
        "Network"
        "WebDevelopment"
      ];
      mimeType = [ "application/json" ];
      settings = {
        StartupWMClass = "postman";
      };
    };
  };

  home.file = lib.mkIf pkgs.stdenv.isLinux {
    # postman

    # beaver
    ".local/share/applications/dbeaver.desktop" = lib.mkIf pkgs.stdenv.isLinux {
      text = ''
        [Desktop Entry]
        Name=DBeaver
        GenericName=DBeaver
        X-GNOME-FullName=DBeaver Community Edition
        Comment=Universal Database Manager
        Keywords=database;sql;
        Exec=${pkgs.dbeaver-bin}/bin/dbeaver
        Terminal=false
        Type=Application
        Icon=${pkgs.dbeaver-bin}/share/icons/hicolor/256x256/apps/dbeaver.png
        Categories=Development;Database;Utilities;
        StartupWMClass=DBeaver
        MimeType=application/sql;
      '';
    };

    # breave
    ".local/share/applications/brave.desktop" = lib.mkIf pkgs.stdenv.isLinux {
      text = ''
        [Desktop Entry]
        Name=Brave
        GenericName=Brave
        X-GNOME-FullName=Brave Browser
        Comment=Web Browser
        Keywords=browser;web;internet;
        Exec=brave
        Terminal=false
        Type=Application
        Icon=${pkgs.brave}/share/icons/hicolor/256x256/apps/brave-browser.png
        Categories=Network;WebBrowser;Utilities;
        StartupWMClass=Brave
        MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/atom+xml;
      '';
    };

    # zed editor
    # ".local/share/applications/zed-editor.desktop" = lib.mkIf pkgs.stdenv.isLinux {
    #   text = ''
    #     [Desktop Entry]
    #     Name=Zed Editor
    #     Comment=Next-Generation Code Editor
    #     Exec=${pkgs.zed-editor}/bin/zeditor
    #     Terminal=false
    #     Type=Application
    #     Icon=${pkgs.zed-editor}/share/icons/hicolor/512x512/apps/zed.png
    #     Categories=Development;TextEditor;Utilities;
    #     StartupWMClass=Zed
    #     MimeType=text/plain;
    #   '';
    # };

    # beekeeper studio
    ".local/share/applications/beekeeper-studio.desktop" = lib.mkIf pkgs.stdenv.isLinux {
      text = ''
        [Desktop Entry]
        Name=Beekeeper Studio
        Comment=SQL Editor and Database Manager
        Exec=${pkgs.beekeeper-studio}/bin/beekeeper-studio --no-sandbox
        Terminal=false
        Type=Application
        Icon=${pkgs.beekeeper-studio}/share/icons/hicolor/512x512/apps/beekeeper-studio.png
        Categories=Development;Database;Utilities;
        StartupWMClass=BeekeeperStudio
        MimeType=application/sql;
      '';
    };
  };

  # Ensure XDG directories are properly set for Ubuntu desktop integration
  xdg.enable = true;

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
    GOPROXY = "https://proxy.golang.org,direct";
    GOPATH = "$HOME/go";
    # GOROOT = "$HOME/go";
  };
}
