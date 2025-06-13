{ inputs, system, pkgs, ... }:
with pkgs;
mkShell {
  buildInputs = with pkgs; [
    php82
    php82Packages.composer
    nginx
    mysql80
    nodejs_20
    yarn
    nmap
  ];

  packages = [

    (writeShellScriptBin "prepare_file" #bash
      ''
        # Membuat direktori runtime
        mkdir -p "$RUNTIME_DIR"
        mkdir -p "$NGINX_DIR"/{conf,temp}
        mkdir -p "$MYSQL_DIR"/{data,socket,logs}
        mkdir -p "$PHP_DIR"
        mkdir -p "$LOGS_DIR"

        # Nginx configuration
        cat > "$NGINX_DIR/conf/nginx.conf" << EOF
        worker_processes 1;
        error_log "$LOGS_DIR/nginx_error.log" error;
        pid "$NGINX_DIR/nginx.pid";

        events {
            worker_connections 1024;
        }

        http {
            include ${pkgs.nginx}/conf/mime.types;
            default_type application/octet-stream;

            access_log "$LOGS_DIR/nginx_access.log";

            client_body_temp_path "$NGINX_DIR/temp/client_body";
            proxy_temp_path "$NGINX_DIR/temp/proxy";
            fastcgi_temp_path "$NGINX_DIR/temp/fastcgi";
            uwsgi_temp_path "$NGINX_DIR/temp/uwsgi";
            scgi_temp_path "$NGINX_DIR/temp/scgi";

            server {
                listen $NGINX_PORT;
                server_name localhost $PROJECT_NAME.local;
                root "$PROJECT_DIR/public";

                index index.php index.html index.htm;

                location / {
                    try_files \$uri \$uri/ /index.php?\$query_string;
                }

                location ~ \.php$ {
                    fastcgi_pass 127.0.0.1:9000;
                    fastcgi_index index.php;
                    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                    include ${pkgs.nginx}/conf/fastcgi_params;
                }

                location ~ /\.ht {
                    deny all;
                }
            }
        }
        EOF

        # PHP FPM configuration
        cat > "$PHP_DIR/php-fpm.conf" << EOF
        [global]
        pid = /tmp/php-fpm.pid
        error_log = /tmp/php-fpm.log
        daemonize = no

        [www]
        listen = 127.0.0.1:9000
        listen.owner = nobody
        listen.group = nobody
        pm = dynamic
        pm.max_children = 5
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
        EOF

        # MySQL configuration
        cat > "$MYSQL_DIR/my.cnf" << EOF
        [mysqld]
        datadir = $MYSQL_DIR/data
        socket = "$MYSQL_DIR/socket/mysql.sock"
        port = $MYSQL_PORT
        bind-address = 127.0.0.1
        log-error = $MYSQL_DIR/logs/error.log
        pid-file = $MYSQL_DIR/mysql.pid

        [client]
        socket = "$MYSQL_DIR/socket/mysql.sock"
        port = $MYSQL_PORT
        EOF
      ''
    )

    (writeShellScriptBin "start_services_php" #bash
      ''
        nix run ~/.nix#nginx --impure
      '')

    (writeShellScriptBin "start_services" #bash
      ''
        echo -e "''${BLUE}🚀 Starting Laravel Development Environment...''${NC}"

        # Initialize MySQL jika belum ada
        if [ ! -d "$MYSQL_DIR/data/mysql" ]; then
            echo -e "''${YELLOW}📦 Initializing MySQL database...''${NC}"
            ${pkgs.mysql80}/bin/mysqld --defaults-file="$MYSQL_DIR/my.cnf" --initialize-insecure --user=$(whoami) --datadir="$MYSQL_DIR/data"
        fi

        # Start MySQL
        echo -e "''${YELLOW}🗄️  Starting MySQL server...''${NC}"
        ${pkgs.mysql80}/bin/mysqld --defaults-file="$MYSQL_DIR/my.cnf" --user=$(whoami) &
        MYSQL_PID=$!
        echo $MYSQL_PID > "$RUNTIME_DIR/mysql.pid"

        # Wait for MySQL to start
        sleep 3

        # Start PHP-FPM
        echo -e "''${YELLOW}🐘 Starting PHP-FPM...''${NC}"
        ${pkgs.php82}/bin/php-fpm -F -y "$PHP_DIR/php-fpm.conf" &
        PHP_FPM_PID=$!
        echo $PHP_FPM_PID > "$RUNTIME_DIR/php-fpm.pid"

        # Start Nginx
        echo -e "''${YELLOW}🌐 Starting Nginx server...''${NC}"
        ${pkgs.nginx}/bin/nginx -c "$NGINX_DIR/conf/nginx.conf" &
        NGINX_PID=$!
        echo $NGINX_PID > "$RUNTIME_DIR/nginx.pid"

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

        # Create database
        sleep 2
        ${pkgs.mysql80}/bin/mysql --socket="$MYSQL_DIR/socket/mysql.sock" -u root -e "CREATE DATABASE IF NOT EXISTS laravel;"

        # Run migrations
        echo -e "''${YELLOW}🔄 Running database migrations...''${NC}"
        ${pkgs.php82}/bin/php artisan migrate --force

        echo -e "''${GREEN}✅ Laravel Development Environment Started!''${NC}"
        echo -e "''${GREEN}🌍 Application: http://localhost:$NGINX_PORT''${NC}"
        echo -e "''${GREEN}🌍 Alternative: http://$PROJECT_NAME.local:$NGINX_PORT''${NC}"
        echo -e "''${GREEN}🗄️  MySQL: localhost:$MYSQL_PORT (user: root, no password)''${NC}"
        echo -e "''${YELLOW}📝 Logs directory: $LOGS_DIR''${NC}"
        echo -e "''${BLUE}💡 Run 'stop_services' to stop all services''${NC}"
      '')
    (writeShellScriptBin "stop_services" #bash
      ''
        echo -e "''${YELLOW}🛑 Stopping services...''${NC}"

        # Stop Nginx
        if [ -f "$RUNTIME_DIR/nginx.pid" ]; then
            kill $(cat "$RUNTIME_DIR/nginx.pid") 2>/dev/null || true
            rm -f "$RUNTIME_DIR/nginx.pid"
        fi

        # Stop PHP-FPM
        if [ -f "$RUNTIME_DIR/php-fpm.pid" ]; then
            kill $(cat "$RUNTIME_DIR/php-fpm.pid") 2>/dev/null || true
            rm -f "$RUNTIME_DIR/php-fpm.pid"
        fi

        # Stop MySQL
        if [ -f "$RUNTIME_DIR/mysql.pid" ]; then
            kill $(cat "$RUNTIME_DIR/mysql.pid") 2>/dev/null || true
            rm -f "$RUNTIME_DIR/mysql.pid"
        fi

      '')
    (writeShellScriptBin "cleanup_on_exit" #bash 
      ''
        echo -e "\n''${YELLOW}🔄 Cleaning up on exit...''${NC}"
        stop_services

        # Clean up
        echo -e "''${YELLOW}🧹 Cleaning up runtime files...''${NC}"
        rm -rf "$RUNTIME_DIR"

        echo -e "''${GREEN}✅ All services stopped and cleaned up!''${NC}"
      '')

    (writeShellScriptBin "helpme" #bash
      ''
        echo -e "\n''${BLUE}🎉 Welcome to Laravel Development Environment!''${NC}"
        echo -e "''${BLUE}Available commands:''${NC}"
        echo -e "  • ''${GREEN}prepare_file''${NC}    - Prepare File"
        echo -e "  • ''${GREEN}start_services''${NC}  - Start all services"
        echo -e "  • ''${GREEN}stop_services''${NC}   - Stop all services"
        echo -e "  • ''${GREEN}php artisan''${NC}     - Laravel artisan commands"
        echo -e "  • ''${GREEN}composer''${NC}        - Composer package manager"
        echo -e "  • ''${GREEN}npm/yarn''${NC}        - Node package managers"
      '')
  ];

  shellHook = #bash 
    ''
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
      export MYSQL_PORT="3306"
      export LARAVEL_PORT="8000"

      export ENABLE_MYSQL=true

      # Direktori untuk runtime files
      export RUNTIME_DIR="$PROJECT_DIR/.nix-runtime"
      export NGINX_DIR="$RUNTIME_DIR/nginx"
      export MYSQL_DIR="$RUNTIME_DIR/mysql"
      export LOGS_DIR="$RUNTIME_DIR/logs"
      export PHP_DIR="$RUNTIME_DIR/php"

      prepare_file

      # Register cleanup function
      trap cleanup_on_exit EXIT INT TERM

      # Auto-start services
      # start_services
      helpme;
    '';
}
