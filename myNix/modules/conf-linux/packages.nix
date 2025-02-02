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
    nodejs
    nodePackages.pnpm

    #compiler
    gnumake
    glib
    cmake
    ninja
    clang
    pkg-config
    gtk3
    gcc
    glibc

    # terminal
    ncdu
    flameshot
    git
    htop
    arandr
    ripgrep
    unzip
    lsd
    bat

    go
    android-studio

    # package for better audio
    # fvm
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

}
