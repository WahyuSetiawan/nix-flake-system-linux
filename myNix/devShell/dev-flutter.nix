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

    # remote device
    scrcpy

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

    (writeShellScriptBin "generate" #bash
      ''
        dart run build_runner build --delete-conflicting-outputs  
      '')

    (writeShellScriptBin "clean" #bash 
      ''
        fvm flutter clean
        fvm flutter pub get 
      '')
    (writeShellScriptBin "buildIos" #bash 
      ''
        cleanIos
        fvm flutter build ipa
      '')

    (writeShellScriptBin "buildApk" #bash
      ''
        clean
        fvm flutter build apk
        fvm flutter build appbundle  
      '')

    (writeShellScriptBin "cleanIos" #bash 
      ''
        	clean
        	fvm flutter precache --ios
        	cd ./ios && arch -x86_64 pod repo update
        	cd ./ios && arch -x86_64 pod update
        	cd ./ios && arch -x86_64 pod install --repo-update
      '')

    (writeShellScriptBin "helpme" #bash 
      ''
         __usage="
         Welcome into shell development flutter

         helper: 
        
        1. emu $\{name emulator} = for running emulator on android
        2. clean = for clean dependencies project and pull again 
        3. cleanIos = for clean dependencies project and pull again for ios platform
        4. buildApk = for build project into apk and appbundle
        5. buildIos = for build project into ipa 
        "

         echo "$__usage";
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
      helpme;
    '';
}
