{ inputs, ... }: {
  imports = [
    ./system.nix
    ./networking.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./services
  ];
}
