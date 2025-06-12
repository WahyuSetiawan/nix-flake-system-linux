{ inputs, pkgs, ... }: {
  fonts.packages = with pkgs; [
    sketchybar-app-font
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
    lsd
    bat
    neovim
    bat
    gitflow
    tldr
    eza
    htop
    tree
    stow
    curl
    wget
    fzf
    gnumake
    ripgrep
    gcc
    fvm

    stow
    cachix

    home-manager

    nixd
    jdk17
    firebase-tools

    # rnix-lsp
  ];
}
