{ stdenv, fetchurl, unzip, makeWrapper, dart }:

stdenv.mkDerivation rec {
  pname = "flutter";
  version = "3.13.9";  # Ganti dengan versi Flutter yang Anda inginkan

  src = fetchurl {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz";
    sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";  # Ganti dengan hash yang sesuai
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  buildInputs = [ dart ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out

    # Buat wrapper untuk flutter
    makeWrapper $out/bin/flutter $out/bin/flutter \
      --set PUB_CACHE "$out/.pub-cache" \
      --set FLUTTER_ROOT "$out" \
      --prefix PATH : "${dart}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Flutter is Google's SDK for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.";
    homepage = "https://flutter.dev";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ your-maintainer-name ];
  };
}
