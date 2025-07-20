{ inputs, ... }: {
  imports = [
    ./cinnamon.nix
    ./xserver.nix
    ./pipewire.nix
    ./hyperland.nix
    ./virtualbox.nix
    ./browser.nix
    ./multimedia.nix
    ./office.nix
  ];
}
