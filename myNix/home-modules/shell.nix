args@{ inputs, pkgs, lib, ... }:
let
  dirAllias = ./allias;
  allAllias = inputs.self.util.filesConcatMap {
    inherit lib; dir = dirAllias;
    args = args // { inherit pkgs; };
  };
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

    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };

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
