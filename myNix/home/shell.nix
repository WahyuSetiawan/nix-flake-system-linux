{ inputs, pkgs, lib, config, ... }:
let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
  concatString' = lib.strings.concatStringsSep " && ";
in
{
  home.file.".zshrc".text =
    if pkgs.stdenv.isDarwin then
    #sh
      ''
        export FVM_CACHE_PATH="$HOME/.fvm"
        export ANDROID_HOME="$HOME/Library/Android/sdk"

        export BUN_PATH="~/.bun/bin"

        export PATH="$PATH:$BUN_PATH"
        export PATH="$PATH:$HOME/Library/Android/sdk/tools/"
        export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
        export PATH="$PATH:$HOME/fvm/default/bin"

        export GOPATH="$HOME/.go"
        export GOBIN="$GOPATH/bin"

        export PATH="$PATH:$GOBIN"

        export _JAVA_OPTIONS="-Xmx2g"
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        # __conda_setup="$('/Users/wahyu/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        # if [ $? -eq 0 ]; then
        # #    eval "$__conda_setup"
        # else
        #     if [ -f "/Users/wahyu/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        #         . "/Users/wahyu/opt/anaconda3/etc/profile.d/conda.sh"
        #     else
        #         export PATH="/Users/wahyu/opt/anaconda3/bin:$PATH"
        #     fi
        # fi
        # unset __conda_setup
        # <<< conda initialize <<<

        # pnpm
        export PNPM_HOME="/Users/wahyu/Library/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        #export JAVA_HOME="/usr/libexec/java_home -v 17"
        #export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
        export JAVA_HOME="/Users/wahyu/.sdkman/candidates/java/current"
        # add flutterfire
        export PATH="$PATH:$HOME/.pub-cache/bin:$JAVA_HOME/bin"

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # bun completions
        [ -s "/Users/wahyu/.bun/_bun" ] && source "/Users/wahyu/.bun/_bun"

        # bun
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
        export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

        PATH=~/.console-ninja/.bin:$PATH

        ## [Completion]
        ## Completion scripts setup. Remove the following line to uninstall
        # [[ -f /Users/wahyu/.dart-cli-completion/zsh-config.zsh ]] && . /Users/wahyu/.dart-cli-completion/zsh-config.zsh || true
        ## [/Completion]

        #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
        export SDKMAN_DIR="$HOME/.sdkman"
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

        # Herd injected PHP 8.3 configuration.
        export HERD_PHP_83_INI_SCAN_DIR="/Users/wahyu/Library/Application Support/Herd/config/php/83/"

        # Herd injected PHP binary.
        export PATH="/Users/wahyu/Library/Application Support/Herd/bin/":$PATH

        # Created by `pipx` on 2024-12-20 22:27:06
        export PATH="$PATH:/Users/wahyu/.local/bin"

        export PATH="$PATH:~/result/bin"
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
        export PATH="/usr/bin/:$PATH"
      ''
    else '''';

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
        then "darwin-rebuild build --flake ${nixConfigDirectory}#default" else
          "nixos-rebuild build --flake ${nixConfigDirectory}#default --use-remote-sudo";
      nixswitch =
        if pkgs.stdenv.isDarwin
        then "darwin-rebuild switch --flake ${nixConfigDirectory}#default" else
          "nixos-rebuild switch --flake ${nixConfigDirectory}#default --use-remote-sudo";

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
      gifsf = "git flow start feature";
      gifsr = "git flow start release";
      gifff = "git flow finish feature";
      giffr = "git flow finish release";
    };
  };

  programs = {
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;

    dircolors.enable = true;
    dircolors.enableFishIntegration = true;

    thefuck.enable = true;
    thefuck.enableInstantMode = true;
    thefuck.enableFishIntegration = true;
    thefuck.enableBashIntegration = false;

    fish = {
      enable = true;
      shellInit = ''

      '';
      functions = {
        nix-dev = ''
          if test (count $argv) -gt 0
              set package $argv[1]
          else
              set package "flutter"
          end
          nix develop ${nixConfigDirectory}#$package -c $SHELL
        '';
      };
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
      #
      # zsh = {
      #   enable = false;
      #   zplug = {
      #     enable = true;
      #     plugins = [
      #       { name = "zsh-users/zsh-autosuggestions"; }
      #     ];
      #   };
      #   oh-my-zsh = {
      #     enable = true;
      #     theme = "cloud";
      #     extraConfig = ''
      #
      #   '';
      #     plugins = [
      #       "git"
      #       "heroku"
      #       "pip"
      #       "lein"
      #       "laravel"
      #       "gradle"
      #       "archlinux"
      #       "docker"
      #       "dnf"
      #       "aws"
      #       "golang"
      #       "command-not-found"
      #     ];
      #   };
      # };

    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
