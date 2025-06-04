{ pkgs, lib, config, osConfig, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
  concatString' = lib.strings.concatStringsSep " && ";
  username = osConfig.users.primaryUser.username;
in
{
  imports = [
    ./shells/alias.nix
  ];

  home.sessionVariables = {
    PATH = "$HOME/fvm/default/bin:$PATH";
  };

  home = {
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      python = "python3";
      pod = "arch -x86_64 pod";
      ".." = "cd ..";

      # allias for nix
      nixclean = concatString' [
        "nix profile wipe-history"
        "nix-collect-garbage"
        "nix-collect-garbage -d"
        "nix-collect-garbage --delete-old"
        "nix store gc"
        "nix store optimise"
        "nix-store --verify --repair --check-contents"
      ];
      nixda = "direnv allow";
      nixdr = "direnv reload";
      nixbuild =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild build --flake ${nixConfigDirectory}#${username}" else
          "nixos-rebuild build --flake ${nixConfigDirectory}#${username} --use-remote-sudo";
      nixdryrun =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild dry-run --flake ${nixConfigDirectory}#${username}" else
          "nixos-rebuild dry-run --flake ${nixConfigDirectory}#${username} --use-remote-sudo";
      nixswitch =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild switch --flake ${nixConfigDirectory}#${username}" else
          "nixos-rebuild switch --flake ${nixConfigDirectory}#${username} --use-remote-sudo";

      # git 
      gia = "git add";
      gico = "git commit -m";
      gibe = "git branch ";
      gice = "git checkout";
      giceb = "git checkout -b ";
      gipull = "git pull";
      gipas = "git push -u origin --all";
      gipus = "git push -u origin";
      gitas = "git status";
      gifi = "git flow init";
      gifsf = "git flow feature start";
      gifsr = "git flow release start";
      gifff = "git flow feature finish";
      giffr = "git flow release finish";
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
