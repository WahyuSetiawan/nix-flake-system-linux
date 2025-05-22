{ modulesPath, inputs, lib, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./shells.nix
    ./packages.nix

    ./conf-linux/fonts.nix
    ./conf-linux/activations.nix
    # ./conf-linux/system.nix
    ./conf-linux/services
    ./conf-linux/packages.nix
    ./conf-linux/programs
  ];

  nix = {
    settings.trusted-users = [ "@wheel" ];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };


  # nixpkgs.hostPlatform = system;
  # system.stateVersion = stateVersion;

  nixpkgs.config.allowUnfree = true;

  boot = {
    blacklistedKernelModules = [ "pcspkr" ];
    plymouth.enable = true;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;

      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
    };
  };
}
