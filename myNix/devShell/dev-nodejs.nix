{ pkgs, ... }:
with pkgs;
mkShell {
  name = "nodejs-dev-shell";

  # Paket yang diinstal di environment
  buildInputs = with pkgs; [
    nodejs_20
    pnpm

    prisma-engines
    prisma
    sqlite

    # Build sqlite
    nodePackages.node-gyp
    python3
    python3Packages.setuptools
    python3Packages.distutils-extra
    pkg-config
    python3Packages.pip

    # Build tools
    openssl

    # Language servers for better performance
    vscode-langservers-extracted
    vue-language-server
    typescript-language-server

    # Additional performance improvements
    nodePackages.typescript
    nodePackages.eslint_d # Faster ESLint daemon
  ];

  packages = [
    (writeShellScriptBin "start_services" ''
      alacritty -e nix run ~/.nix#server-dev --impure > /dev/null 2>&1 & 
          ALACRITTY_PID=$!
          touch $TMP_DIR/server.pid;
          echo $ALACRITTY_PID > $TMP_DIR/server.pid 
    '')

    (writeShellScriptBin "stop_services" ''
      echo -e "''${YELLOW}🛑 Stopping services...''${NC}"

      # Stop Nginx
      if [ -f "$TMP_DIR/server.pid" ]; then
          kill $(cat "$TMP_DIR/server.pid") 2>/dev/null || true
          rm -f "$TMP_DIR/server.pid"
      fi
    '')

    (writeShellScriptBin "optimize_vscode" ''
      echo "🚀 Optimizing VS Code for Node.js development..."

      # Create optimized VS Code settings
      mkdir -p .vscode
      cat > .vscode/settings.json << EOF
      {
        "typescript.preferences.includePackageJsonAutoImports": "off",
        "typescript.suggest.autoImports": true,
        "typescript.suggest.enabled": true,
        "typescript.suggest.paths": true,
        "typescript.preferences.useLabelDetailsInCompletionEntries": true,
        "typescript.updateImportsOnFileMove.enabled": "always",
        "typescript.inlayHints.parameterNames.enabled": "literals",
        "typescript.inlayHints.variableTypes.enabled": false,
        "typescript.inlayHints.functionLikeReturnTypes.enabled": true,
        
        "search.exclude": {
          "**/node_modules": true,
          "**/dist": true,
          "**/build": true,
          "**/.next": true,
          "**/.nuxt": true,
          "**/coverage": true,
          "**/.cache": true
        },
        
        "files.watcherExclude": {
          "**/node_modules/**": true,
          "**/dist/**": true,
          "**/build/**": true,
          "**/.next/**": true,
          "**/.nuxt/**": true,
          "**/coverage/**": true,
          "**/.cache/**": true
        },
        
        "files.exclude": {
          "**/node_modules": false,
          "**/dist": true,
          "**/build": true,
          "**/.cache": true
        },
        
        "eslint.useFlatConfig": true,
        "eslint.experimental.useFlatConfig": true,
        "eslint.runtime": "node",
        
        "editor.codeActionsOnSave": {
          "source.fixAll.eslint": "explicit"
        },
        
        "extensions.experimental.affinity": {
          "ms-vscode.vscode-typescript-next": 1,
          "bradlc.vscode-tailwindcss": 1,
          "vue.volar": 1
        },
        
        "typescript.tsserver.maxTsServerMemory": 8192,
        "typescript.workspaceSymbols.scope": "currentProject",
        "typescript.preferences.includePackageJsonAutoImports": "auto"
      }
      EOF

      echo "✅ VS Code optimized for better performance!"
    '')

    (writeShellScriptBin "help_me" ''
      echo "🚀 Node.js development shell ready!"
      echo "Node: $(node --version)"
      echo "Pnpm: $(pnpm --version)"
      echo "TypeScript: $(npx tsc --version 2>/dev/null || echo 'Not available')"

      echo -e "Available commands:"
      echo -e " "
      echo -e "- start_services    : Start all services"
      echo -e "- stop_services     : Stop all services"
      echo -e "- optimize_vscode   : Setup VS Code for optimal performance"
      echo -e "- help_me           : Show all commands"
      echo -e " "
      echo -e "💡 Performance Tips:"
      echo -e "- Run 'optimize_vscode' to setup optimal VS Code settings"
      echo -e "- Use pnpm instead of npm for faster package management"
      echo -e "- Exclude node_modules from search and file watchers"
    '')
  ];

  # Variabel environment untuk performance optimization
  shellHook = ''
    if [ -z "$SHELL_INITIALIZED" ]; then
      export SHELL_INITIALIZED=1
      export PATH="$PATH:$(pwd)/node_modules/.bin"
      export SQLITE3_LIB_DIR="${pkgs.sqlite.out}/lib"

      export TMP_DIR=$(mktemp -d -t "myapp-$(date +%s)-XXXXXX")

      # Prisma configuration
      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      export PKG_CONFIG_PATH="${pkgs.sqlite.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export SQLITE3_INCLUDE_DIR="${pkgs.sqlite.dev}/include"
      
      # Performance optimizations
      export NODE_OPTIONS="--max-old-space-size=8192"
      export TS_NODE_TRANSPILE_ONLY=true
      export TS_NODE_SKIP_IGNORE=true
      
      # VS Code performance
      export VSCODE_TSJS_LOCALE="en"
      export TSS_LOG="-level verbose -file /tmp/tss.log"
      
      # Disable telemetry for better performance
      export NEXT_TELEMETRY_DISABLED=1
      export NUXT_TELEMETRY_DISABLED=1
      export ADBLOCK=1
      export DISABLE_OPENCOLLECTIVE=1
      
      echo "Prisma engine path: $PRISMA_SCHEMA_ENGINE_BINARY"
      echo "Node memory limit: 8GB"
      
      # Auto-run optimization if .vscode doesn't exist
      if [ ! -d ".vscode" ]; then
        echo "🔧 Setting up VS Code optimization..."
        optimize_vscode
      fi
      
      help_me
    fi
  '';
}
