{ inputs, system, pkgs, ... }: with pkgs ;mkShell {
  name = "nodejs-dev-shell";

  # Paket yang diinstal di environment
  packages = with pkgs; [
    nodejs_20
    pnpm
    git

    prisma-engines
    prisma

    openssl

    dbeaver-bin

    vscode-langservers-extracted
  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      echo "Prisma engine path: $PRISMA_SCHEMA_ENGINE_BINARY"

      echo "🚀 Node.js development shell ready!"
      echo "Node: $(node --version)"
      echo "Pnpm: $(pnpm --version)"
    '';
}
