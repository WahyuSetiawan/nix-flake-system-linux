{ pkgs, config, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
in
{

  home.packages = with pkgs; [
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
  ];
}
