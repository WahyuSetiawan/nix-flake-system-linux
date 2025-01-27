let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
  pname = "fvm";
  version = "0.5.1";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/fvm-sh/fvm/v0.5.1/install.sh";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Ganti dengan checksum
  };

  nativeBuildInputs = [ pkgs.bash pkgs.curl pkgs.coreutils ];

  buildPhase = ''
    echo "Nothing to build"
  '';

  installPhase = ''
    mkdir -p $out/bin
    bash ./install.sh
    cp -r ~/.fvm/bin/* $out/bin/
  '';

  meta = {
    description = "Flutter Version Manager (FVM)";
    homepage = "https://github.com/fvm-sh/fvm";
    license = "MIT";
  };
}

