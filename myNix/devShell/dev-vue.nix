{ inputs, system, pkgs, ... }: with pkgs ;mkShell {
  name = "development vue";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    nodejs_20
    yarn
    pnpm
    git

    prisma-engines
    prisma

    openssl

    dbeaver-bin

    # nodePackages.babel-loader
    # pkgs.nodePackages.webpack
    # # Jika membutuhkan core Babel:
    # pkgs.nodePackages."@babel/core"
    # pkgs.nodePackages."@babel/preset-env"
  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
        # Install vscode-eslint-language-server secara lokal
      if [ ! -d "node_modules/.bin/vscode-eslint-language-server" ]; then
        npm install --save-dev vscode-languageserver @types/vscode-languageserver
        npm install --save-dev vscode-eslint-language-server
      fi

      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      echo "Prisma engine path: $PRISMA_SCHEMA_ENGINE_BINARY"

      echo "🚀 Node.js development shell ready!"
      echo "Node: $(node --version)"
      echo "Yarn: $(yarn --version)"
    '';
}
