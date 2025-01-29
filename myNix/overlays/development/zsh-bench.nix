{ pkgs
, lib
, stdenv
, ...
}: pkgs.stdenv.mkDerivation {
  pname = "zsh-bench";
  version = "v1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "romkatv";
    repo = "zsh-bench";
    rev = "master";
    sha256 = "0WGiDULubwQ9RDzKMVe39X149orpXxhPajM7nQSFT5I=";
  };

  # Tidak ada dependency runtime, hanya perlu coreutils untuk copy file
  buildInputs = [ pkgs.coreutils ];

  # Tidak ada build process, kita hanya memastikan file tersedia di output
  buildPhase = ''
    echo "Nothing to build."
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin/
    chmod +x $out/bin/zsh-bench
  '';

  meta = {
    description = "Zsh benchmark";
    homepage = "https://github.com/romkatv/zsh-bench/tree/master";
    maintainers = [
      "wahyu setiawan"
    ];
  };
} 
