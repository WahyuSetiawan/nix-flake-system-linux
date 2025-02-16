args'@ { ... }: {
  perSystem = { pkgs, config, system, inputs', ... }: with pkgs;   {
    devShells = {
      flutter = import ./dev-flutter.nix {
        inherit (args') inputs;
        inherit pkgs system;
      };
    };
  };
}

