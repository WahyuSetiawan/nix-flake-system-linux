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
  ];
}
