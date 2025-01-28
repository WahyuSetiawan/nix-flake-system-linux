# pkgs/fvm/default.nix
{ pkgs
, lib
, stdenv
}:
let
  platform = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";
  version = "3.2.1";
  filename = "fvm-${version}-${platform}-${arch}.tar.gz";
  downloadUrl = "https://github.com/leoafarias/fvm/releases/download/${version}/${filename}";
in
stdenv.mkDerivation {
  pname = "fvm";
  inherit version;

  src = pkgs.fetchurl {
    url = downloadUrl;
    sha256 =
      if stdenv.isDarwin then
        "sha256-N1zm4P4F54MEDDiGC0FfrYtAVIv+B3h57Djk/IhTsVo="
      else
        "sha256-Oejr20a5PeHCrtv6mqdRA+8Wyb9QBIqSjvcKu7RW9Pg=";
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
    mkdir -p $out/libexec
    
    # Extract archive ke direktori yang sesuai
    tar xzf $src -C $out/libexec
    
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
