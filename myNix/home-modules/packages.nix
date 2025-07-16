{ inputs, pkgs, config, lib, args, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
in
{
  imports = [
    ./packages-flutter.nix
  ];

  # nixGL configuration - only for Linux
  nixGL = lib.mkIf pkgs.stdenv.isLinux {
    packages = import inputs.nixgl { inherit pkgs; };
    defaultWrapper = "nvidiaPrime";
    offloadWrapper = "nvidiaPrime";
    installScripts = [ "mesa" "nvidiaPrime" ];
  };

  home.packages = with pkgs; [
    # termianl tool
    wget
    curl
    eza
    fzf
    lazygit
    neovim

    # development
    killall
    xclip


    # ui aplication
    postman

    # terminal
    ncdu
    git
    htop
    gitflow
    ripgrep
    unzip
    lsd
    bat

    # tui
    ranger
    nixd

    go
    nodejs
    pnpm

    lua-language-server
    inputs.oxalica-nil.packages.${pkgs.system}.nil

    nodejs
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
    fantasque-sans-mono
    nerd-fonts.symbols-only

    (writeShellScriptBin "nxdev" #bash 
      ''
        if [ -z "$1" ]; then
            echo "Usage: nxdev <object>"
            exit 1
        fi
        nix develop ${nixConfigDirectory}\#$1 -c $SHELL
      '')
    (writeShellScriptBin "nxrun" #bash
      ''
        if [ -z "$1" ]; then
          echo "Usage: nix run <object>"
          exit 1
        fi

        nix run ${nixConfigDirectory}\#$1 
      '')

    (writeShellScriptBin "nxclean" #bash
      ''
        nix profile wipe-history
        nix-collect-garbage
        nix-collect-garbage -d
        nix-collect-garbage --delete-old
        nix store gc
        nix store optimise
        nix-store --verify --repair --check-contents
      '')

    (writeShellScriptBin "emu"  #bash 
      ''
        if [ -z "$1" ]; then
          echo "Usage: run-emulator <device_id>"
          exit 1
        fi

        nohup emulator -avd "$1" -gpu swiftshader_indirect > /dev/null 2>&1 &
      '')

    (writeShellScriptBin "start_n8n" #bash
      ''
        if  ! docker volume ls | grep n8n_data; then 
          docker volume create n8n_data
        fi

        docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
      '')

    (writeShellScriptBin "op_redis" #bash
      ''
        nix-shell -p redis --run "redis-cli"
      '')
  ] ++ (if pkgs.stdenv.isLinux then [
    # Linux-specific applications
    nemo
    arandr
    wl-clipboard
  ] else [ ]);
}
