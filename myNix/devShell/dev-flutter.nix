{ inputs, system, pkgs, ... }:
with pkgs;
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
  conditionalPackages = if pkgs.system != "aarch64-darwin" then [ android-studio ] else [ ];
in
mkShell {
  name = "Development Flutter";

  packages = [
    fvm

    # android tools
    gradle
    jdk
    android-sdk

    #linux tool chain
    cmake
    ninja
    clang
    pkg-config
    gtk3

    (writeShellScriptBin "emu"  #bash 
      ''
      if [ -z "$1" ]; then
        echo "Usage: run-emulator <device_id>"
        exit 1
      fi

      nohup emulator -avd "$1" -gpu swiftshader_indirect > /dev/null 2>&1 &
      '')
  ];

  buildInputs = [
    # webbrowser tools
    google-chrome
  ] ++ conditionalPackages;

  env = {
    "ANDROID_HOME" = "${android-sdk}/share/android-sdk";
    "ANDROID_SDK_ROOT" = "${android-sdk}/share/android-sdk";
    "JAVA_HOME" = jdk.home;
    CHROME_EXECUTABLE = "${google-chrome}/bin/google-chrome-stable";
  };

  shellHook = #bash
    ''
      echo "Welcome into shell development flutter ";
      echo "\n"
        
      echo "Helper :"
      echo "1. emu param : for launch parameter"
    '';
}
