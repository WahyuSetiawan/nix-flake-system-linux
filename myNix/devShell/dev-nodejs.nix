{ pkgs, ... }:
with pkgs ;mkShell {
  name = "nodejs-dev-shell";

  # Paket yang diinstal di environment
  buildInputs = with pkgs; [
    nodejs_20
    pnpm

    prisma-engines
    prisma
    sqlite


    # build sqlite
    nodePackages.node-gyp
    python3
    python3Packages.setuptools
    python3Packages.distutils-extra
    pkg-config
    python3Packages.pip
    # Build tools

    openssl

    dbeaver-bin

    vscode-langservers-extracted
    vue-language-server
    typescript-language-server
  ];

  packages = [
    (writeShellScriptBin "start_services" #bash
      ''
        alacritty -e nix run ~/.nix#server-dev --impure > /dev/null 2>&1 & 
            ALACRITTY_PID=$!
            touch $TMP_DIR/server.pid;
            echo $ALACRITTY_PID > $TMP_DIR/server.pid 
      '')

    (writeShellScriptBin "stop_services" #bash
      ''
        echo -e "''${YELLOW}🛑 Stopping services...''${NC}"

        # Stop Nginx
        if [ -f "$TMP_DIR/server.pid" ]; then
            kill $(cat "$TMP_DIR/server.pid") 2>/dev/null || true
            rm -f "$TMP_DIR/server.pid"
        fi

      '')

    (writeShellScriptBin "help_me" #bash
      ''
        echo "🚀 Node.js development shell ready!"
        echo "Node: $(node --version)"
        echo "Pnpm: $(pnpm --version)"

        echo -e "Available command : "
        echo -e " "
        echo -e "- start_services : Start all services"
        echo -e "- stop_services : Stop all services"
        echo -e "- help_me : Show all command"
      '')

  ];

  # Variabel environment (opsional)
  shellHook =
    #bash 
    ''
      direnv allow .
      export PATH="$PATH:$(pwd)/node_modules/.bin"
      export SQLITE3_LIB_DIR="${pkgs.sqlite.out}/lib"

      export TMP_DIR=$(mktemp -d -t "myapp-$(date +%s)-XXXXXX")

      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      export PKG_CONFIG_PATH="${pkgs.sqlite.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export SQLITE3_LIB_DIR="${pkgs.sqlite.out}/lib"
      export SQLITE3_INCLUDE_DIR="${pkgs.sqlite.dev}/include"
      echo "Prisma engine path: $PRISMA_SCHEMA_ENGINE_BINARY"

      help_me
    '';
}
