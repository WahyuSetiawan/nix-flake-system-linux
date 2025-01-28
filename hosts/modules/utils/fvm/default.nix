# pkgs/fvm/default.nix
{ pkgs, lib, stdenv }:
let
  # Tentukan platform dan arsitektur
  platform = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  # Versi spesifik yang akan digunakan
  version = "2.4.1";

  # Konstruksi nama file berdasarkan platform
  filename = "fvm-${version}-${platform}-${arch}.tar.gz";

  # URL download yang sesuai
  downloadUrl = "https://github.com/leoafarias/fvm/releases/download/${version}/${filename}";
in
stdenv.mkDerivation {
  pname = "fvm";
  inherit version;

  src = pkgs.fetchurl {
    url = downloadUrl;
    # Anda perlu mengganti hash ini setelah mencoba build pertama kali
    sha256 = "sha256-hs55tyYJFyQZGSdLf0pBhoO4F/2hd8aUySeCqHYTyhU=";
  };

  nativeBuildInputs = with pkgs; [
    curl
    git
    unzip
    which
  ];

  buildInputs = with pkgs; [
    bash
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/fvm
    
    # Extract archive ke direktori yang sesuai
    tar xzf $src -C $out/libexec/fvm
    
    # Buat wrapper script
    cat > $out/bin/fvm <<EOF
    #!${pkgs.bash}/bin/bash
    export FVM_DIR="$out/libexec/fvm"
    export PATH="${lib.makeBinPath (with pkgs; [ git curl unzip ])}:\$PATH"
    exec $out/libexec/fvm/fvm "\$@"
    EOF
    
    chmod +x $out/bin/fvm
  '';

  meta = with lib; {
    description = "Flutter Version Manager";
    homepage = "https://github.com/leoafarias/fvm";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
