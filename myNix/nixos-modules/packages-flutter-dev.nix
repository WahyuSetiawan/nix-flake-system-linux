{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    #editor
    android-studio

    fvm

    jdk17

    #linux tool chain
    cmake
    ninja
    clang
    pkg-config
    gtk3
    pkg-config

    firebase-tools

    google-chrome
  ];
}
