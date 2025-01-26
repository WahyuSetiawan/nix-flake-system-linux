{ system, stateVersion, ... }: ({ self, pkgs, ... }: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = system;
  system.stateVersion = stateVersion;

  nixpkgs.config.allowUnfree = true;
})
