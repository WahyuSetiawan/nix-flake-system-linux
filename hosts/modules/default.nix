{ ... }: {
  flake.commonModules = {
    system-shell = import ./shells.nix;
    system-packages = import ./packages.nix;
  };

  flake.darwinModules = {
    system-darwin-packages = import ./conf-darwin/packages.nix;
  };

  flake.nixosModules = {
    system-nixos-networking = import ./conf-linux/networking.nix;
    system-nixos-system = import ./conf-linux/system.nix;
    system-nixos-services = import ./conf-linux/services.nix;
    system-nixos-packages = import ./conf-linux/packages.nix;
    system-nixos-programs = import ./services;

    system-nixos-hardware=  import ./conf-linux/hardware;
  };
}
