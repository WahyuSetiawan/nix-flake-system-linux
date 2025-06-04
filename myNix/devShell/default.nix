args'@ { ... }: {
  imports = [
    ../services/default.nix
  ];
  perSystem = { pkgs, config, system, inputs', ... }: with pkgs;   {
    devShells = {
      flutter = import ./dev-flutter.nix {
        inherit (args') inputs;
        inherit pkgs system;
      };
      laravel = import ./dev-laravel.nix {
        inherit (args') inputs;
        inherit pkgs system;
      };
      rust = import ./dev-rust.nix {
        inherit (args') inputs;
        inherit pkgs system;
      };
      nodejs = import ./dev-nodejs.nix {
        inherit (args') inputs;
        inherit pkgs system;
      };
    };
  };
}

