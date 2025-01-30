{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    fantasque-sans-mono
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs ;[
    xdg-desktop-portal
    android-studio
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

    jetbrains-mono
    openjdk21

    go

    # package for better audio
    fvm
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

}
