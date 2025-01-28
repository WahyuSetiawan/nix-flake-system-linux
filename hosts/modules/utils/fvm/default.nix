# pkgs/fvm/default.nix
{ pkgs, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "fvm";
  version = "2.4.1";

  src = pkgs.fetchFromGitHub {
    owner = "leoafarias";
    repo = "fvm";
    rev = version;
    sha256 = "lib.fakeSha256"; # Update setelah error pertama
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

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/fvm

    curl -fsSL https://fvm.app/install.sh > installer.sh
    
    substituteInPlace installer.sh \
      --replace 'FVM_DIR="$HOME/.fvm"' 'FVM_DIR="$out/libexec/fvm"' \
      --replace 'SYMLINK_TARGET="$HOME/bin"' 'SYMLINK_TARGET="$out/bin"'

    chmod +x installer.sh

    export HOME=$out
    export PATH="${lib.makeBinPath nativeBuildInputs}:$PATH"
    
    ./installer.sh

    cat > $out/bin/fvm <<EOF
    #!${pkgs.bash}/bin/bash
    export FVM_DIR="$out/libexec/fvm"
    export PATH="${lib.makeBinPath nativeBuildInputs}:\$PATH"
    exec $out/libexec/fvm/bin/fvm "\$@"
    EOF

    chmod +x $out/bin/fvm
  '';

  meta = with lib; {
    description = "Flutter Version Manager";
    homepage = "https://fvm.app";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
