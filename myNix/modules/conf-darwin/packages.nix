inputs@{ pkgs, ... }: {
  environment.systemPackages = with pkgs;[
    w3m
    clang
    nixpkgs-fmt
    libiconv
    iconv
    cargo
    rustc
    lsd
    bat
    neovim
    lazygit
    bat
    gitflow
    btop
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
  ];
}
