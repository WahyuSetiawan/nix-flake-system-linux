input: {
  flake.homeManagerModules = {
    home-activation = import ./activations.nix;
    home-shell = import ./shell.nix;
    home-terminal = import ./terminal.nix;
    home-git = import ./git.nix;
    home-packages = import ./packages.nix;
    home-tmux = import ./tmux.nix;
    home-hyprland = import ./hyprland;
  };
}
