{ self, inputs, ... }: {
  perSystem = { pkgs, config, system, inputs', ... }: with pkgs;   {
    devShells = {
      flutterold =
        let
          android-sdk = inputs.android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            build-tools-34-0-0
            platform-tools
            platforms-android-34
            emulator
          ]
          ++ lib.optionals (system == "aarch64-darwin") [
            system-images-android-34-google-apis-arm64-v8a
            system-images-android-34-google-apis-playstore-arm64-v8a
          ]
          ++ lib.optionals (system == "x86_64-darwin" || system == "x86_64-linux") [
            system-images-android-34-google-apis-x86-64
            system-images-android-34-google-apis-playstore-x86-64
          ]
          );

        in
        mkShell {
          name = "develop-flutter";
          buildInputs = [
            fvm
            openjdk17
            pkgs.xcodebuild
            clang
            cmake
            ninja
            pkg-config

            pkg-config
            gtk3.dev
            cairo.dev
            glib.dev
            pango.dev

            xorg.libXxf86vm
            xorg.libX11
            xorg.libXrender
            xorg.libXext
            xorg.libXinerama
            xorg.libxcb
            xorg.libxkbfile

            # lib for graphics emulator
            libpulseaudio
            gtk3
            gtk3-x11
            pkgs.nss
            pkgs.xorg.libXcomposite
            xorg.libXcursor
            xorg.libXi
            xorg.libXtst
            xorg.libXrandr
            pkgs.alsa-lib
            pkgs.atk
            pkgs.mesa
            pkgs.libglvnd

            libpng
            nss
            nspr
            expat
            libdrm
            libbsd

            qt5.qtbase
            qt5.qtwayland
            qt5.qtx11extras

            fontconfig
            freetype
            alsa-lib
            libpulseaudio
            libxkbcommon
            libxcrypt
            glib
            networkmanager

            libuuid # for mount.pc
            xorg.libXdmcp.dev
            python310Packages.libselinux.dev # for libselinux.pc
            libsepol.dev
            libthai.dev
            libdatrie.dev
            libxkbcommon.dev
            dbus.dev
            at-spi2-core.dev
            xorg.libXtst.out
            pcre2.dev

            android-sdk
          ] ++ lib.optionals (system == "x86_64-linux") [
            android-studio
          ]
          ;

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
          pkgs.xorg.libX11
          pkgs.xorg.libXrender
          pkgs.xorg.libXext
          pkgs.xorg.libXinerama
          pkgs.xorg.libXi
          pkgs.xorg.libXrandr
          pkgs.xorg.libXtst
          pkgs.xorg.libXcursor
          pkgs.xorg.libxkbfile
          pkgs.xorg.libXxf86vm

          pkgs.libpulseaudio
          pkgs.libpng
          pkgs.nss
          pkgs.nspr
          pkgs.expat
          pkgs.libdrm
          pkgs.libbsd
          pkgs.xorg.libxcb
          pkgs.libxkbcommon

          pkgs.qt5.qtbase
          fontconfig.lib
          sqlite.out
          chromium
        ]}";

          QT_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-5.${pkgs.qt5.qtbase.version}/plugins";

          ANDROID_AVD_HOME = "$HOME/.android/avd";
          ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
          ANDROID_HOME = "$HOME/Android/Sdk";

          CHROME_EXECUTABLE = "chromium";

          shellHook = #sh
            ''
              export QT_QPA_PLATFORM=xcb
         
              export PATH=$PATH:$ANDROID_HOME/tools
              export PATH=$PATH:$ANDROID_HOME/platform-tools
              export ANDROID_AVD_HOME="$HOME/.android/avd";

              export ANDROID_HOME="${android-sdk}/share/android-sdk"
              export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

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
