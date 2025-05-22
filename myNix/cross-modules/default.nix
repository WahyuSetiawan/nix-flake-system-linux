{...}:{
  flake.crossModules = {
    home-manager = import ./home-manager.nix;
    packages = import ./packages.nix;
  };
}
