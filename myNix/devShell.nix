{ self, ... }: {
  perSystem = { pkgs, config, ... }: builtins.trace "membuat shell development" {
    devShells = with pkgs; {
      flutter = mkShell {
        name = "develop-flutter";
        buildInputs = [
          fvm
          jdk17
        ];
        shellHook = #sh
          ''
            export FLUTTER_HOME=$HOME/fvm;
            export PATH="$FLUTTER_HOME/bin:$PATH";
            echo "Entering development Flutter mode;"
          '';
      };
    };
  };
}
