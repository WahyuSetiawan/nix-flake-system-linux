input: {
  flake.homeManagerModules = {
    home-shell = import ./shell.nix;
  };
}
