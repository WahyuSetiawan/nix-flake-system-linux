{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) mkIf;
in
{
  environment.shellInit =
    ''
      eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';

  system.activationScripts.preUserActivation.text =
    ''
      if [ ! -f ${config.homebrew.brewPrefix}/brew ]; then
        ${pkgs.bash}/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

  homebrew.enable = true;
  homebrew.brews = [
    
  ];
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.masApps = {
    xCode = 497799835;
    WhatsApp = 310633997;
  };

  homebrew.casks = [
  ];

}
