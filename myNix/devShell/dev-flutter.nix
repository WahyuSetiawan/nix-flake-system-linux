{ inputs, system, pkgs, ... }:
with pkgs;
let
  android-sdk = inputs.android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    platform-tools
    emulator

    ndk-26-1-10909125
    ndk-26-3-11579264
    ndk-27-0-12077973

    build-tools-31-0-0
    build-tools-32-0-0
    build-tools-34-0-0
    build-tools-35-0-0
    platforms-android-31
    platforms-android-33
    platforms-android-34
    platforms-android-35
  ]
  ++ lib.optionals (system == "aarch64-darwin") [
    system-images-android-34-google-apis-arm64-v8a
    system-images-android-34-google-apis-playstore-arm64-v8a

    system-images-android-35-google-apis-arm64-v8a
    system-images-android-35-google-apis-playstore-arm64-v8a
  ]
  ++ lib.optionals (system == "x86_64-darwin" || system == "x86_64-linux") [
    system-images-android-34-google-apis-x86-64
    system-images-android-34-google-apis-playstore-x86-64

    system-images-android-35-google-apis-x86-64
    system-images-android-35-google-apis-playstore-x86-64
  ]
  );

  conditionalPackages =
    if pkgs.system != "aarch64-darwin" then [
      android-studio
    ] else [
      ruby
      xcodebuild
      xcbuild
      cocoapods
    ];

  extranShellHook =
    if pkgs.stdenv.isDarwin then #bash 
      ''
        # Set Xcode path
        export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
        export XCODE_PATH="/Applications/Xcode.app"
    
        # Set iOS SDK path
        export SDKROOT="$DEVELOPER_DIR/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    
        # Add Xcode tools to PATH
        export PATH=$PATH:$DEVELOPER_DIR/usr/bin
        export PATH=$PATH:$DEVELOPER_DIR/Tools
    
        # Set up CocoaPods environment
        export GEM_HOME=$PWD/.gem
        export PATH=$GEM_HOME/bin:$PATH
      '' else #bash 
      ''

    '';
in
mkShell {
  name = "Development Flutter";

  packages = [
    # flutter
    fvm

    # remote device
    scrcpy

    # android tools
    jdk17
    android-sdk

    #linux tool chain
    cmake
    ninja
    clang
    pkg-config
    gtk3

    firebase-tools

    chromium

    (writeShellScriptBin "scrcpy" ''
         scrcpy --no-audio >> /dev/null 2>&1 &
        '')

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
        6. scrcpy = launch scrcpy on background
        "

         echo "$__usage";
      '')
  ] ++ conditionalPackages;

  env = {
    "ANDROID_HOME" = "${android-sdk}/share/android-sdk";
    "ANDROID_SDK_ROOT" = "${android-sdk}/share/android-sdk";
    ANDROID_NDK_ROOT = "${android-sdk}/share/android-sdk/ndk";
    "JAVA_HOME" = "${pkgs.jdk17}";
    CHROME_EXECUTABLE = "${chromium}/bin/chromium";
    DEVELOPER_DIR = "/Applications/Xcode.app/Contents/Developer";
    XCODE_PATH = "/Applications/Xcode.app/Contents/Developer";
  };

  shellHook = #bash
    ''
      ${extranShellHook}

      flutter config --jdk-dir $JAVA_HOME
      flutter config --android-sdk $ANDROID_SDK_ROOT

      helpme;
    '';
}
