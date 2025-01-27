{ inputs, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      (import ./utils/zsh-bench.nix)
      w3m
      clang
      nixpkgs-fmt
      libiconv
      iconv
      cargo
      rustc
      lsd
      vim
      bat
      neovim
      lazygit
      kitty
      alaritty
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
    ];



}
