{ pkgs, ... }: with pkgs;
[
  scrcpy
  fvm

  # jdk21

  android-tools

  # #linux tool chain
  cmake
  ninja
  clang
  pkg-config

  scrcpy

  # firebase-tools  # broken with nodejs 24
]
++ (if pkgs.stdenv.isLinux then [
  adb-sync

  # Linux-specific application
  android-studio
  gtk3

      firebase-tools

      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
    ]
  else
    [ ]
)
