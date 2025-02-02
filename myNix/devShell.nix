{ self, ... }: {
  perSystem = { pkgs, config, ... }: {
    devShells = with pkgs; {
      flutter = mkShell {
        name = "develop-flutter";
        buildInputs = [
          fvm
          openjdk21
          pkgs.xcodebuild
          clang
        ];
        shellHook = #sh
          ''
            export XCODE_PATH=/Applications/Xcode.app/Contents/Developer
             export SDKROOT=$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
             export CPATH=$SDKROOT/usr/include
             export LIBRARY_PATH=$SDKROOT/usr/lib

            export FVM_CACHE_PATH=$HOME/.fvm;
            export FVM_CACHE_PATH_BIN="$FVM_CACHE_PATH/default/bin";
            export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer";

            export FLUTTER_HOME="$FVM_CACHE_PATH/default";
            export PATH="$FVM_CACHE_PATH_BIN:$PATH";

            echo "Entering development Flutter mode;"
          '';
      };
    };
  };
}
