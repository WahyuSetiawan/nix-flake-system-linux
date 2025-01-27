{ inputs, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      w3m
      starship
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
