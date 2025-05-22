{...}:{
  flake.crossModules = {
    home-manager = import ./home-manager.nix;
    packages = import ./packages.nix;
    shells = import ./shells.nix;
    user = import ./user.nix;
  };
}
