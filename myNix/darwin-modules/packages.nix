{ inputs, pkgs, ... }: {
  fonts.packages = with pkgs; [
    # sketchybar-app-font  # disabled: npm install fails with SSL cert error in sandbox
    # sf-mono-liga-bin
    sf-symbols-font

    # name of nerdfonts see {https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix}
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs;[
    nixpkgs-fmt
    libiconv
    iconv
    cargo
    rustc
    neovim
    bat
    tldr
    tree
    stow
    gnumake
    gcc
    fvm

    stow
    cachix

    home-manager

    nixd
    # firebase-tools  # broken with nodejs 24
    alacritty

    docker
    docker-compose
  ];
}
