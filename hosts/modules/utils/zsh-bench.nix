{ pkgs, ... }: pkgs.stdenv.mkDerivation {
  pname = "zsh-bench";
  version = "v1.0.0";
  src = fetchGit {
    url = "https://github.com/romkatv/zsh-bench";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  meta = {
    description = "Zsh benchmark";
    homepage = "https://github.com/romkatv/zsh-bench/tree/master";
    maintainers = [
      "wahyu setiawan"
    ];
  };
} 
