{ pkgs, ... }: with pkgs; [
  scrcpy
  fvm

  # jdk21

  adb-sync
  android-tools

  # #linux tool chain
  cmake
  ninja
  clang
  pkg-config

  scrcpy  

  firebase-tools
] ++ (if pkgs.stdenv.isLinux then [
  # Linux-specific application
  android-studio
  gtk3

  # google-chrome

  xorg.libX11
  xorg.libXext
  xorg.libXrender
  xorg.libXtst
  xorg.libXi
] else [ ])
