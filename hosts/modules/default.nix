{ ... }: {
  flake.commonModules = {
    system-shell = import ./shells.nix;
    system-user = import ./users.nix;
    system-packages = import ./packages.nix;
  };

  flake.darwinModules = [

  ];


  flake.nixosModules = {
    system-nixos-networking = import ./conf-linux/networking.nix;
    system-nixos-system = import ./conf-linux/system.nix;
    system-nixos-services = import ./conf-linux/services.nix;
    system-nixos-programs = import ./services;
  };
}
