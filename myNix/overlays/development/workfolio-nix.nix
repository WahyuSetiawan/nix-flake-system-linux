{
  pkgs,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "workfolio";
  version = "0.1.46";

  src = pkgs.fetchurl {
    url = "https://workfolio-public.s3.ap-south-1.amazonaws.com/workfolio_0.1.46_amd64.deb";
    sha256 = "sha256-o1A+dHXRL+VOuk+J8DNYvYGC8ZlokApXPzsDmMLASlY=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    libappindicator-gtk3
    libdrm
    libnotify
    libpulseaudio
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    pango
    systemd
    xdg-utils
    stdenv.cc.cc.lib
    gcc-unwrapped.lib
    sqlite
    gtk2
    zlib
    openssl
    libGL
    libGLU
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxcb
    libxshmfence
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall
        
    mkdir -p $out/opt
    mkdir -p $out/bin
    mkdir -p $out/share
        
    cp -r usr/share/* $out/share/
    cp -r opt/workfolio/* $out/opt/

    if [ -f $out/share/applications/workfolio.desktop ]; then
      substituteInPlace $out/share/applications/workfolio.desktop \
        --replace "/opt/workfolio/workfolio" "$out/opt/workfolio/workfolio"
    fi
        
    runHook postInstall
  '';

  postFixup = ''
    find $out/opt -type f -executable -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \;

    wrapProgram $out/opt/workfolio \
              --prefix LD_LIBRARY_PATH : "${
                pkgs.lib.makeLibraryPath [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.gcc-unwrapped.lib
                  pkgs.sqlite
                  pkgs.zlib
                  pkgs.openssl
                  pkgs.libGL
                  pkgs.libGLU
                ]
              }" \
           --set GDK_BACKEND x11
  '';

  meta = with lib; {
    description = "Employee monitoring and timesheets for remote teams";
    homepage = "https://www.getworkfolio.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
