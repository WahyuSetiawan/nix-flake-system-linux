{ pkgs, ... }: {
  home.packages = with pkgs; [
    scrcpy
    fvm

    jdk17

    # #linux tool chain
    cmake
    ninja
    clang
    pkg-config

    firebase-tools

    # libxkbcommon
    # libglvnd
    # fontconfig
    # ncurses5
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
     ]
    else 
      [  ]);

   home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
  };
}
