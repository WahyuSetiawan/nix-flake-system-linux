{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];
}
