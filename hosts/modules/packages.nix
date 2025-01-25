{ config, pkgs, ... }: {

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    freetype
    vimPlugins.fzfWrapper

    # tools utils
    wget
    curl
    eza
    fzf
    tmux
    lazygit

    xdg-desktop-portal
    libva
    libva-utils
    # libva-mesa-driver

    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    })
    # browser
    vivaldi-ffmpeg-codecs

    # development
    neovim
    android-studio
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
    kitty
    starship
    ncdu
    flameshot
    git
    htop
    arandr
    ripgrep
    unzip
    lsd
    bat

    jetbrains-mono
    openjdk21

    go

  ];

  # Install firefox.
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
  # Aktifkan Home Manager untuk pengguna tertentu


}
