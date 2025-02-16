{ pkgs, ... }: {
  environment.systemPackages = with pkgs ;[
    xdg-desktop-portal
    home-manager
    # reetype
    vimPlugins.fzfWrapper

    # tools utils
    wget
    curl
    eza
    fzf
    lazygit

    libva
    libva-utils
    # libva-mesa-driver

    # development
    neovim
    xclip # Untuk X11
    wl-clipboard # Untuk Wayland

    # nodejs
    # nodePackages.pnpm

    #compiler
    # gnumake
    # glib
    # pkg-config
    # gtk3
    # gcc
    # glibc

    # terminal
    ncdu
    git
    htop
    arandr
    ripgrep
    unzip
    lsd
    bat

    # go
    # android-studio

    # package for better audio
    # fvm
    postman
  ];

  environment.variables = rec{
    FVM_CACHE_PATH = "$HOME/.fvm";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    PATH = [
      "${FVM_CACHE_PATH}/default/bin"
    ];
  };

  # programs = {
  #   avd = true;
  # };

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

}
