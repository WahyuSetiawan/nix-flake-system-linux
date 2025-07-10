{ pkgs, ... }:
with pkgs; mkShell {
  name = "development golang";

  # Paket-paket yang dibutuhkan
  buildInputs = with pkgs; [
    # Golang dan tools dasar
    go
    gopls
    delve
    go-outline
    gopkgs
    gocode-gomod
    godef

    # Tools tambahan yang berguna
    gotools
    govulncheck
    golangci-lint

    # Build tools
    gnumake
    cmake

    # Version control
    git

    mysql-client
    postgresql
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

        echo "Go development environment ready!"
        echo "Go version: $(go version)"
      '')

  ];

  # Environment variables untuk Golang
  shellHook = ''
    direnv allow .

    export GOPATH="$HOME/go"
    export PATH=$PATH:$(go env GOPATH)/bin
    export PATH="$GOPATH/bin:$PATH"

    go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest
    
    help_me
  '';
}
