{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  binutils,
  wrapGAppsHook,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libxkbcommon,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
  ffmpeg,
  libuuid,

}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  pname = "vivaldi";
  version = "7.4.3684.43";
  
  srcs =
    let
      base = "https://downloads.vivaldi.com/stable";
    in
    rec {
      x86_64-linux = {
        url = "${base}/vivaldi-stable_${version}-1_amd64.deb";
        sha256 = "sha256-tDGoew5jEOqoHIHSvoOsBcuEzq817YT0pFSO3Li48OU="; # Update dengan hash yang benar
      };
      aarch64-linux = {
        url = "${base}/vivaldi-stable_${version}-1_arm64.deb";
        sha256 = "sha256-tDGoew5jEOqoHIHSvoOsBcuEzq817YT0pFSO3Li48OU="; # Update dengan hash yang benar
      };
    };
  
  src = fetchurl (srcs.${system} or throwSystem);
  
  meta = with lib; {
    description = "A browser for our friends";
    homepage = "https://vivaldi.com";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ ];
  };

  buildInputs = [
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
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ];

  runtimeDependencies = [
    ffmpeg
    libuuid
  ];

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      buildInputs
      runtimeDependencies
      ;

    nativeBuildInputs = [
      dpkg
      binutils
      wrapGAppsHook
      autoPatchelfHook
    ];

    # Ignore missing Qt dependencies
    autoPatchelfIgnoreMissingDeps = [
      "libQt5Core.so.5"
      "libQt5Gui.so.5" 
      "libQt5Widgets.so.5"
      "libQt6Core.so.6"
      "libQt6Gui.so.6"
      "libQt6Widgets.so.6"
    ];

    unpackPhase = ''
      runHook preUnpack
      
      # Extract .deb manually to avoid SUID permission issues
      echo "Extracting Vivaldi .deb package..."
      ar x $src
      
      # Extract data.tar.xz with proper permissions handling
      if [ -f data.tar.xz ]; then
        tar -xf data.tar.xz --no-same-owner --no-same-permissions --warning=no-unknown-keyword
      elif [ -f data.tar.gz ]; then
        tar -xf data.tar.gz --no-same-owner --no-same-permissions --warning=no-unknown-keyword
      else
        echo "Error: No data archive found in .deb package"
        exit 1
      fi
      
      # Fix sandbox permissions manually
      if [ -f opt/vivaldi/vivaldi-sandbox ]; then
        chmod 755 opt/vivaldi/vivaldi-sandbox
      fi
      
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      # Create directories
      mkdir -p $out/bin $out/share

      # Copy application files
      cp -r opt/vivaldi $out/share/
      cp -r usr/share/* $out/share/

      # Create wrapper script
      cat > $out/bin/vivaldi << EOF
      #!${stdenv.shell}
      exec $out/share/vivaldi/vivaldi "\$@"
      EOF
      chmod +x $out/bin/vivaldi

      # Create alternative binary names
      ln -sf $out/bin/vivaldi $out/bin/vivaldi-stable
      ln -sf $out/bin/vivaldi $out/bin/vivaldi-browser

      # Fix desktop file
      if [ -f $out/share/applications/vivaldi-stable.desktop ]; then
        substituteInPlace $out/share/applications/vivaldi-stable.desktop \
          --replace /opt/vivaldi/vivaldi $out/bin/vivaldi \
          --replace /opt/vivaldi/product_logo_256.png vivaldi
      fi

      runHook postInstall
    '';

    postFixup = ''
      # Add missing libraries to RPATH
      for file in $out/share/vivaldi/vivaldi $out/share/vivaldi/vivaldi-bin; do
        if [ -f "$file" ]; then
          echo "Patching $file"
          patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $file 2>/dev/null || echo "")" $file || true
        fi
      done

      # Handle vivaldi-sandbox separately (it needs special treatment)
      if [ -f "$out/share/vivaldi/vivaldi-sandbox" ]; then
        echo "Patching vivaldi-sandbox"
        chmod 755 $out/share/vivaldi/vivaldi-sandbox
        patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $out/share/vivaldi/vivaldi-sandbox 2>/dev/null || echo "")" $out/share/vivaldi/vivaldi-sandbox || true
      fi

      # Fix any additional binaries but skip problematic Qt shim libraries
      find $out/share/vivaldi -type f -executable | while read file; do
        # Skip Qt shim libraries as they're optional and cause build failures
        if [[ "$file" == *"libqt5_shim.so"* ]] || [[ "$file" == *"libqt6_shim.so"* ]]; then
          echo "Skipping Qt shim: $file"
          continue
        fi
        
        if file "$file" | grep -q "ELF.*executable"; then
          echo "Patching executable: $file"
          patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$(patchelf --print-rpath $file 2>/dev/null || echo "")" "$file" || true
        fi
      done
    '';

    dontStrip = true;
    dontPatchELF = false;
  };
in
linux
