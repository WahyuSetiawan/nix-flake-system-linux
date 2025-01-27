{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "fvm";
  version = "latest";

  # src = pkgs.fetchFromGitHub {
  #   owner = "fvm-sh";
  #   repo = "fvm";
  #   rev = "main";
  #   sha256 = "j70SOyuEQ61Ku82Z2GYieh/ALiKRXxe3GygDbz7OAuo="; # Ganti dengan checksum
  # };

  src = pkgs.fetchurl {
    url = "https://fvm.app/install.sh";
    sha256 = "sha256-Qubwqm6PiqfLyQAvLHxzEFELosQAE+uXzF1CX0WuMKk="; # Ganti dengan checksum yang benar
  };

  unpackPhase = "true";

  nativeBuildInputs = [ pkgs.bash pkgs.curl pkgs.coreutils ];

  buildPhase = ''
    echo "Nothing to build"
  '';

  installPhase = ''
    # Menjalankan script install.sh
    mkdir -p $out/bin
    mkdir -p $out/fvm

    sed -i "s/FVM_DIR=\".*\"/FVM_DIR=\"$out/fvm\"" $src 
    sed -i "s/SYMLINK_TARGET=\".*\"/SYMLINK_TARGET=\"$out/bin\"" $src 
    bash $src

    # Memastikan fvm tersedia di $out/bin
    cp -r ~/.fvm/bin/* $out/bin/
  '';

  meta = {
    description = "Flutter Version Manager (FVM)";
    homepage = "https://github.com/fvm-sh/fvm";
    license = "MIT";
  };
}

