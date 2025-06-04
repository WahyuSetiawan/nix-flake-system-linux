inputs@{ pkgs, lib, ... }:
let
  dirAllias = ./allias;
  alliasContents = builtins.readDir dirAllias;

  # Filter hanya file .nix, kecuali default.nix jika ada
  nixFiles = lib.filterAttrs
    (name: type: type == "regular" && lib.strings.hasSuffix ".nix" name && name != "default.nix")
    alliasContents;

  allAllias = lib.foldl'
    (acc: name:
      acc // (import (dirAllias + "/${name}") { inherit (inputs) lib config osConfig; inherit pkgs;})
    )
    { }
    (lib.attrNames nixFiles);
in
{
  home.sessionVariables = {
    PATH = "$HOME/fvm/default/bin:$PATH";
  };

  home = {
    shellAliases =
      allAllias //
      {
        ls = "lsd";
        cat = "bat";
        python = "python3";
        pod = "arch -x86_64 pod";
        ".." = "cd ..";


      };
  };

  programs = {
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;

    dircolors.enable = true;
    dircolors.enableFishIntegration = true;

    # thefuck.enable = true;
    # thefuck.enableInstantMode = true;
    # thefuck.enableFishIntegration = true;
    # thefuck.enableBashIntegration = false;

    fish = {
      enable = true;
      shellInit = ''

      '';
      functions = { };
    };

    zsh = {
      enable = false;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggesrions"; }
        ];
      };
      oh-my-zsh = {
        enable = true;
        theme = "cloud";
        extraConfig = ''
      '';
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
