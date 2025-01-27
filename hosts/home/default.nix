input: {
  flake.homeManagerModules = {
    home-shell = import ./shell.nix;
    home-terminal = import ./terminal.nix;
    home-git = import ./git.nix;
    home-packages = import ./packages.nix;
    home-tmux = import ./home-tmux;
  };
}
