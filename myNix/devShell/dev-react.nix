{ inputs, system, pkgs, ... }: with pkgs ;mkShell {
  name = "Development React";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    nodejs_20
    pnpm
    git
    openssl
    vscode-langservers-extracted

    typescript-language-server
    vue-language-server
    tailwindcss-language-server
  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      echo "🚀 React development shell ready!"
      echo "Node: $(node --version)"
      echo "Pnpm: $(pnpm --version)"
    '';
}
