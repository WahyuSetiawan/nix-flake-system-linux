{ pkgs, ... }: {
  home.packages = with pkgs; [
    #editor
    android-studio

    scrcpy
    fvm

    jdk17

    #linux tool chain
    cmake
    ninja
    clang
    pkg-config
    gtk3

    firebase-tools

    google-chrome

    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi

    libxkbcommon
    libglvnd
    fontconfig
    ncurses5
  ];

   home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
  };
}
