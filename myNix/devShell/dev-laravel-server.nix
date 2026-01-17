{
  inputs,
  system,
  pkgs,
  ...
}:
with pkgs;
mkShell {
  buildInputs = with pkgs; [
    php82
    php82Packages.composer
    nginx
    mysql80
    nodejs_20
    pnpm
    nmap
  ];

  packages = [
    (writeShellScriptBin "migrate_database" # bash
      ''
        MYSQL_HOST="localhost"
        TIMEOUT=60  # dalam detik
        INTERVAL=2  # interval pengecekan dalam detik
        MYSQL_READY=false

        echo "Menunggu MySQL pada $MYSQL_HOST:$MYSQL_PORT..."

        # Hitung waktu akhir berdasarkan timeout
        end_time=$((SECONDS + TIMEOUT))

        while [ $SECONDS -lt $end_time ]; do
            # Cek koneksi ke port MySQL
            if nc -z "$MYSQL_HOST" "$MYSQL_PORT" >/dev/null 2>&1; then
                echo "MySQL berjalan pada $MYSQL_HOST:$MYSQL_PORT"
                MYSQL_READY=true
                break;
            fi
            
            # Tunggu sebelum cek lagi
            sleep $INTERVAL
        done

        if [ $MYSQL_READY ]; then
          ${pkgs.mysql80}/bin/mysql --socket="$TMP_DIR/mysql.sock" -u root -e "CREATE DATABASE IF NOT EXISTS laravel;"

          # Run migrations
          echo -e "''${YELLOW}🔄 Running database migrations...''${NC}"
          ${pkgs.php82}/bin/php artisan migrate --force
        fi

      ''
    )
    (writeShellScriptBin "start_services" # bash
      ''
        # Ensure base directory exists first
        if [ -z "$TMP_DIR" ] || [ ! -d "$TMP_DIR" ]; then 
          export TMP_DIR=/tmp/laravel-dev-$(date +%s)-$$
          mkdir -p "$TMP_DIR"
        fi

        alacritty -e nix run ~/.nix#laravel --impure 2>&1 | tee "$LOGS_DIR/server.log" &
        ALACRITTY_PID=$!
        touch "$TMP_DIR/server.pid"
        echo $ALACRITTY_PID > "$TMP_DIR/server.pid"

        # Install Laravel dependencies jika belum ada
        if [ ! -d "vendor" ]; then
            echo -e "''${YELLOW}📦 Installing Laravel dependencies...''${NC}"
            ${pkgs.php82Packages.composer}/bin/composer install
        fi

        # Setup Laravel environment
        if [ ! -f ".env" ]; then
            echo -e "''${YELLOW}⚙️  Setting up Laravel environment...''${NC}"
            cp .env.example .env
            ${pkgs.php82}/bin/php artisan key:generate
        fi

        # Update .env for development
        sed -i "s/DB_HOST=.*/DB_HOST=127.0.0.1/" .env
        sed -i "s/DB_PORT=.*/DB_PORT=$MYSQL_PORT/" .env
        sed -i "s/DB_DATABASE=.*/DB_DATABASE=laravel/" .env
        sed -i "s/DB_USERNAME=.*/DB_USERNAME=root/" .env
        sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=/" .env

        migrate_database

        echo -e "''${GREEN}✅ Laravel Development Environment Started!''${NC}"
        echo -e "''${GREEN}🌍 Application: http://localhost:$NGINX_PORT''${NC}"
        echo -e "''${GREEN}🌍 Alternative: http://$PROJECT_NAME.local:$NGINX_PORT''${NC}"
        echo -e "''${GREEN}🗄️  MySQL: localhost:$MYSQL_PORT (user: root, no password)''${NC}"
        echo -e "''${YELLOW}📝 Logs directory: $LOGS_DIR''${NC}"
        echo -e "''${BLUE}💡 Run 'stop_services' to stop all services''${NC}"

      ''
    )

    (writeShellScriptBin "open_mysql" # bash
      ''
        ${pkgs.mysql80}/bin/mysql --socket="$TMP_DIR/mysql.sock" -u root 
      ''
    )

    (writeShellScriptBin "stop_services" # bash
      ''
        echo -e "''${YELLOW}🛑 Stopping services...''${NC}"

        # Stop Alacritty and all child processes
        if [ -f "$TMP_DIR/server.pid" ]; then
            MAIN_PID=$(cat "$TMP_DIR/server.pid")
            if ps -p $MAIN_PID > /dev/null 2>&1; then
                echo -e "''${YELLOW}🛑 Stopping Alacritty (PID: $MAIN_PID) and all child processes...''${NC}"
                # Kill the process group to ensure all children are terminated
                pkill -P $MAIN_PID 2>/dev/null || true
                kill $MAIN_PID 2>/dev/null || true
                sleep 1
                # Force kill if still running
                kill -9 $MAIN_PID 2>/dev/null || true
            fi
            rm -f "$TMP_DIR/server.pid"
        fi

        # Stop MySQL explicitly
        if [ -f "$MYSQL_DIR/mysql.pid" ]; then
            MYSQL_PID=$(cat "$MYSQL_DIR/mysql.pid")
            if ps -p $MYSQL_PID > /dev/null 2>&1; then
                echo -e "''${YELLOW}🛑 Stopping MySQL (PID: $MYSQL_PID)...''${NC}"
                kill $MYSQL_PID 2>/dev/null || true
                sleep 1
                kill -9 $MYSQL_PID 2>/dev/null || true
            fi
            rm -f "$MYSQL_DIR/mysql.pid"
        fi

        # Stop Nginx explicitly
        if [ -f "$NGINX_DIR/nginx.pid" ]; then
            NGINX_PID=$(cat "$NGINX_DIR/nginx.pid")
            if ps -p $NGINX_PID > /dev/null 2>&1; then
                echo -e "''${YELLOW}🛑 Stopping Nginx (PID: $NGINX_PID)...''${NC}"
                kill $NGINX_PID 2>/dev/null || true
                sleep 1
                kill -9 $NGINX_PID 2>/dev/null || true
            fi
            rm -f "$NGINX_DIR/nginx.pid"
        fi

        # Stop PHP-FPM explicitly
        if [ -f "$PHP_DIR/php-fpm.pid" ]; then
            PHP_PID=$(cat "$PHP_DIR/php-fpm.pid")
            if ps -p $PHP_PID > /dev/null 2>&1; then
                echo -e "''${YELLOW}🛑 Stopping PHP-FPM (PID: $PHP_PID)...''${NC}"
                kill $PHP_PID 2>/dev/null || true
                sleep 1
                kill -9 $PHP_PID 2>/dev/null || true
            fi
            rm -f "$PHP_DIR/php-fpm.pid"
        fi

        # Kill any remaining MySQL processes using our socket
        pkill -f "mysql.*$MYSQL_SOCKET_DIR" 2>/dev/null || true

        # Kill any remaining Nginx processes on our port
        pkill -f "nginx.*$NGINX_PORT" 2>/dev/null || true

        # Kill any remaining PHP-FPM processes
        pkill -f "php-fpm.*$PROJECT_NAME" 2>/dev/null || true

        # Clean up socket files
        rm -f "$TMP_DIR/mysql.sock" 2>/dev/null || true
        rm -f "$TMP_DIR/mysql.sock.lock" 2>/dev/null || true

        echo -e "''${GREEN}✅ All services stopped!''${NC}"
      ''
    )

    (writeShellScriptBin "cleanup_on_exit" # bash
      ''
        echo -e "\n''${YELLOW}🔄 Cleaning up on exit...''${NC}"
        stop_services

        # Clean up
        echo -e "''${YELLOW}🧹 Cleaning up runtime files...''${NC}"
        rm -rf "$RUNTIME_DIR"

        echo -e "''${GREEN}✅ All services stopped and cleaned up!''${NC}"
      ''
    )

    (writeShellScriptBin "helpme" # bash
      ''
        echo -e "\n''${BLUE}🎉 Welcome to Laravel Development Environment!''${NC}"
        echo -e "''${BLUE}Available commands:''${NC}"
        echo -e "  • ''${GREEN}open_mysql''${NC}      - Into Mysql"
        echo -e "  • ''${GREEN}migrate_database''${NC}- Migrations database applications"
        echo -e "  • ''${GREEN}start_services''${NC}  - Start all services"
        echo -e "  • ''${GREEN}stop_services''${NC}   - Stop all services"
        echo -e "  • ''${GREEN}php artisan''${NC}     - Laravel artisan commands"
        echo -e "  • ''${GREEN}composer''${NC}        - Composer package manager"
        echo -e "  • ''${GREEN}npm/yarn''${NC}        - Node package managers"
      ''
    )
  ];

  shellHook = # bash
    ''
      # if [ -z "$SHELL_INITIALIZED" ]; then
      #   export SHELL_INITIALIZED=1

        # Warna untuk output
        export RED='\033[0;31m'
        export GREEN='\033[0;32m'
        export YELLOW='\033[1;33m'
        export BLUE='\033[0;34m'
        export NC='\033[0m' # No Color

        # Variabel konfigurasi
        export PROJECT_NAME="laravel-dev"
        export PROJECT_DIR="$(pwd)"
        export NGINX_PORT="8086"
        export MYSQL_PORT="$(grep DB_PORT .env 2>/dev/null | cut -d '=' -f 2 || echo '3306')"
        export LARAVEL_PORT="8000"

        export ENABLE_MYSQL=true
        export ENABLE_MYSQL="$(grep DB_CONNECTION .env 2>/dev/null | grep -q 'mysql' && echo 'true' || echo 'false')"

        # Direktori untuk runtime files
        export TMP_DIR="$HOME/.local/nix-runtime/${PROJECT_NAME}"
        mkdir -p "$TMP_DIR"

        export RUNTIME_DIR="$TMP_DIR/runtime"
        export NGINX_DIR="$RUNTIME_DIR/nginx"
        export MYSQL_DIR="$RUNTIME_DIR/mysql"
        export LOGS_DIR="$RUNTIME_DIR/logs"
        export PHP_DIR="$RUNTIME_DIR/php"
        export MYSQL_SOCKET_DIR="$TMP_DIR"

        mkdir -p "$NGINX_DIR" "$MYSQL_DIR" "$LOGS_DIR" "$PHP_DIR"

        # Register cleanup function
        # trap cleanup_on_exit EXIT INT TERM

        # Auto-start services
        # start_services
        helpme;
      # fi
    '';
}
