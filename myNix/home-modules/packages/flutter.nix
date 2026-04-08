{ pkgs, ... }:
with pkgs;
[
  scrcpy
  fvm

  jdk21

  # adb-sync  # Temporarily disabled due to broken go-mtpfs dependency
  android-tools

  # #linux tool chain
  cmake
  ninja
  clang
  pkg-config

]
++ (
  if pkgs.stdenv.isLinux then
    [
      # Linux-specific application
      # android-studio
      gtk3

      # google-chrome

      # firebase-tools

      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
    ]
  else
    [ ]
)
