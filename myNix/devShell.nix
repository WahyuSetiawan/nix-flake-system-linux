{ self, ... }: {
  perSystem = { pkgs, config, ... }: {
    devShells = with pkgs; {
      flutter = mkShell {
        name = "develop-flutter";
        buildInputs = [
          fvm
          openjdk21
        ];
        shellHook = #sh
          ''
            export FVM_CACHE_PATH=$HOME/fvm;
            export FVM_CACHE_PATH_BIN="$FVM_CACHE_PATH/default/bin";

            export FLUTTER_HOME="$FVM_CACHE_PATH/default";
            export PATH="$FVM_CACHE_PATH_BIN:$PATH";

            echo "Entering development Flutter mode;"
          '';
      };
    };
  };
}
