{ self, inputs, system, pkgs, ... }:
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
pkgs.devShell.mkShell {
  name = "Development Flutter";

  packages = [
    fvm
    gradle
    jdk
    android-sdk
  ] ++ conditionalPackages;
}
