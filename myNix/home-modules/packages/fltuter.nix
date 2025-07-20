{ pkgs, ... }: with pkgs; [
  scrcpy
  fvm

  jdk17

  # #linux tool chain
  cmake
  ninja
  clang
  pkg-config

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
