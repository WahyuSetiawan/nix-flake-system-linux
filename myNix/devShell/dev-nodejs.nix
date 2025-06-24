{ pkgs, ... }:
let
  name = "testing";
in
with pkgs ;mkShell {
  name = "nodejs-dev-shell";

  # Paket yang diinstal di environment
  buildInputs = with pkgs; [
    nodejs_20
    pnpm

    prisma-engines
    prisma

    openssl

    dbeaver-bin

    vscode-langservers-extracted
  ];

  packages = [
    (writeShellScriptBin "start_services" #bash
      ''
        alacritty -e nix run ~/.nix#server-dev --impure > /dev/null 2>&1 & 
            ALACRITTY_PID=$!
            touch $TMP_DIR/${name}.pid;
            echo $ALACRITTY_PID > $TMP_DIR/${name}.pid 
      '')

    (writeShellScriptBin "help_me" #bash
      ''
        echo "🚀 Node.js development shell ready!"
        echo "Node: $(node --version)"
        echo "Pnpm: $(pnpm --version)"

        echo -e "Available command : "
        echo -e " "
        echo -e "- start_services : Start all services"
        echo -e "- help_me : Show all command"
      '')

  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      direnv allow .
      export TMP_DIR=$(mktemp -d -t "myapp-$(date +%s)-XXXXXX")

      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      echo "Prisma engine path: $PRISMA_SCHEMA_ENGINE_BINARY"

      help_me
    '';
}
