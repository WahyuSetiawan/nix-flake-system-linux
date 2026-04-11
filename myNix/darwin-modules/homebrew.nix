{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
in
{
  environment.shellInit = ''
    eval "$(${config.homebrew.prefix}/bin/brew shellenv)"
  '';

  system.activationScripts.postActivation.text = ''
    if [ ! -f ${config.homebrew.prefix}/bin/brew ]; then
      ${pkgs.bash}/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew = {
    enable = true;
    brews = [
    ];
    taps = [
      "deskflow/tap"
    ];
    onActivation.cleanup = "zap";
    global.brewfile = true;

    masApps = {
      xCode = 497799835;
      WhatsApp = 310633997;
    };

    casks = [
      "deskflow"
    ];
  };
}
