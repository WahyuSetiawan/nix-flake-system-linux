{ ... }: {
  flake.commonModules = {
    system-shell = import ./shells.nix;
    system-packages = import ./packages.nix;
    system-user = import ./user.nix;
  };

  flake.darwinModules = {
    system-darwin-shells = import ./conf-darwin/shells.nix;
    system-darwin-packages = import ./conf-darwin/packages.nix;
    system-darwin-homebrew = import ./conf-darwin/homebrew.nix;
    system-darwin-mouseless = import ./conf-darwin/mouseless.nix;
    system-darwin-tui = import ./conf-darwin/tui.nix;
    system-darwin-system = import ./conf-darwin/system.nix;
    system-darwin-browser = import ./conf-darwin/browser.nix;
  };

  flake.nixosModules = {
    system-nixos-fonts = import ./conf-linux/fonts.nix;
    sysetm-nixos-activations = import ./conf-linux/activations.nix;
    system-nixos-system = import ./conf-linux/system.nix;
    system-nixos-services = import ./conf-linux/services;
    system-nixos-packages = import ./conf-linux/packages.nix;
    system-nixos-programs = import ./conf-linux/programs;
    system-nixos-hardware = import ./conf-linux/hardware;
  };
}
