args'@ { ... }: {
  perSystem = { pkgs, config, system, inputs', ... }: with pkgs;   {
    devShell = {
      flutter2 = import ./dev-flutter.nix {inherit args'; inherit  pkgs system;};
    };
  };
}

