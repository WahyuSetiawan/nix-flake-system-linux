{ self, ... }: {
  perSystem = { pkgs, config, ... }: {
    devShells = with pkgs; {
      flutter = mkShell {
        name = "develop-flutter";
        buildInputs = [
          fvm
          openjdk17
          pkgs.xcodebuild
          clang

          gtk3
          gtk3-x11
          pkg-config
          gtk3.dev
          cairo.dev
          glib.dev
          pango.dev

          xorg.libX11
          xorg.libXrender
          xorg.libXext
          xorg.libXinerama
          xorg.libXi
          xorg.libXrandr
          xorg.libXtst
          xorg.libXcursor
        ];
        shellHook = #sh
          ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                  pkgs.xorg.libX11
                  pkgs.xorg.libXrender
                  pkgs.xorg.libXext
                  pkgs.xorg.libXinerama
                  pkgs.xorg.libXi
                  pkgs.xorg.libXrandr
                  pkgs.xorg.libXtst
                  pkgs.xorg.libXcursor
                ]}


            export ANDROID_AVD_HOME=$HOME/.android/avd

            export ANDROID_HOME=$HOME/Android/Sdk
            export PATH=$PATH:$ANDROID_HOME/tools
            export PATH=$PATH:$ANDROID_HOME/platform-tools

            export XCODE_PATH=/Applications/Xcode.app/Contents/Developer
            export SDKROOT=$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
            export CPATH=$SDKROOT/usr/include
            export LIBRARY_PATH=$SDKROOT/usr/lib

            export FVM_CACHE_PATH=$HOME/.fvm;
            export FVM_CACHE_PATH_BIN="$FVM_CACHE_PATH/default/bin";
            export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer";

            export FLUTTER_HOME="$FVM_CACHE_PATH/default";
            export PATH="$FVM_CACHE_PATH_BIN:$PATH";

            fvm flutter config --android-sdk $ANDROID_HOME;

            echo "Entering development Flutter mode;"
          '';
      };
    };
  };
}
