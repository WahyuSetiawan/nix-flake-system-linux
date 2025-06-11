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
    ./home-manager.nix
    ./ssh.nix
    ./secrets.nix
  ];

  programs.home-manager.enable = true;
}
