args'@ { ... }: {
  imports = [
    ../services/default.nix
  ];

  perSystem = { pkgs, config, system, inputs', ... }:
    let
      args = { inherit (args') inputs; inherit pkgs system; };
    in
    {
      devShells = {
        flutter = import ./dev-flutter.nix args;
        laravel-vue = import ./dev-laravel-vue.nix args;
        laravel-dev = import ./dev-laravel-server.nix args;
        laravel = import ./dev-laravel.nix args;
        rust = import ./dev-rust.nix args;
        nodejs = import ./dev-nodejs.nix args;
        vue = import ./dev-vue.nix args;
      };
    };
}

