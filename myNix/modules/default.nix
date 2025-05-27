{ ... }: {
  flake.commonModules = {
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

}
