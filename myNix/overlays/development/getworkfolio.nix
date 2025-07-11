{ pkgs, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "workfolio";
  version = "0.1.46";

  src = pkgs.fetchurl {
    url = "https://workfolio-public.s3.ap-south-1.amazonaws.com/workfolio_0.1.46_amd64.deb";
    sha256 = "sha256-o1A+dHXRL+VOuk+J8DNYvYGC8ZlokApXPzsDmMLASlY=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    # GLib/Gtk dependencies
    glib
    gtk3
    at-spi2-core
    atk
    cairo
    pango
    gdk-pixbuf
    libdrm
    libxkbcommon

    # Basic system libraries
    glibc
    stdenv.cc.cc.lib
    nss
    nspr
    expat
    alsa-lib
    cups
    mesa

    # X11 libraries
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    electron
    libappindicator-gtk3
  ];

  unpackPhase = ''
    mkdir -p pkg
    dpkg -x $src pkg
  '';

  installPhase = ''
    # Install main files
    mkdir -p $out/opt/workfolio
    cp -r pkg/opt/workfolio/* $out/opt/workfolio/

    # Fix permissions for chrome-sandbox
    chmod 4755 $out/opt/workfolio/chrome-sandbox || true

    # Install desktop file and icons
    mkdir -p $out/share/applications
    cp pkg/usr/share/applications/workfolio.desktop $out/share/applications/

    if [ -d pkg/usr/share/icons ]; then
      mkdir -p $out/share/icons
      cp -r pkg/usr/share/icons/* $out/share/icons/
    fi

    # Create wrapper script with all necessary libraries
    mkdir -p $out/bin
    makeWrapper $out/opt/workfolio/workfolio $out/bin/workfolio \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]}
  '';

  postFixup = ''
    # Patch desktop file
    substituteInPlace $out/share/applications/workfolio.desktop \
      --replace "/opt/workfolio/workfolio" "$out/bin/workfolio"
  '';

  meta = with lib; {
    description = "Workfolio Application";
    homepage = "https://getworkfolio.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
