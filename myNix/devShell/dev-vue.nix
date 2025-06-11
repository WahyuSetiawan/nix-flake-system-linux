{ inputs, system, pkgs, ... }: with pkgs ;mkShell {
  name = "development vue";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    nodejs_20
    pnpm
    git
    openssl

    vscode-langservers-extracted
    typescript-language-server
    vue-language-server
  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      echo "🚀 Node.js development shell ready!"
      echo "Node: $(node --version)"
      echo "Pnpm: $(pnpm --version)"
    '';
}
