{ ... }: {
  imports = [
    ./activations.nix
    ./shell.nix
    ./terminal.nix
    ./git.nix
    ./packages.nix
    ./tmux.nix
    ./hyprland

    ./users.nix
  ];
}
