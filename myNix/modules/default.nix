{ ... }: {
  flake.commonModules = {
    system-shell = import ./shells.nix;
    system-packages = import ./packages.nix;
    system-users = import ./users.nix;
  };

  flake.darwinModules = {
    system-darwin-packages = import ./conf-darwin/packages.nix;
    system-darwin-homebrew = import ./conf-darwin/homebrew.nix;
    system-darwin-mouseless = import ./conf-darwin/mouseless.nix;
  };

  flake.nixosModules = {
    sysetm-nixos-activations = import ./conf-linux/activations.nix;
    system-nixos-system = import ./conf-linux/system.nix;
    system-nixos-services = import ./conf-linux/services;
    system-nixos-packages = import ./conf-linux/packages.nix;
    system-nixos-programs = import ./conf-linux/programs;
    system-nixos-hardware = import ./conf-linux/hardware;
  };
}
