{ inputs, ... }: {
  imports = [
    ./xserver.nix
    ./pipewire.nix
    ./hyperland.nix
    ./virtualbox.nix
    ./browser.nix
    ./multimedia.nix
  ];
}
