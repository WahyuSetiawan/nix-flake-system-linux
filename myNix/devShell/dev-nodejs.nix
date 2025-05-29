{ inputs, system, pkgs, ... }: with pkgs ;mkShell {
  name = "nodejs-dev-shell";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    nodejs_20 # Gunakan nodejs_18, nodejs_20, atau versi lain
    yarn # Ganti dengan `pnpm` atau `npm` jika diperlukan
    git
  ];

  # Variabel environment (opsional)
  shellHook = ''
    echo "🚀 Node.js development shell ready!"
    echo "Node: $(node --version)"
    echo "Yarn: $(yarn --version)"
  '';
}
