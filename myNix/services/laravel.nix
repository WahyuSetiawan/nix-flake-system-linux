{ inputs, pkgs, config, lib, ... }:
let inherit (inputs.services-flake.lib) multiService;
  inherit (inputs.self.util) getEnv;

  phpFpmPort = getEnv "PHPFPM_PORT" "9000";
  nginxPort = getEnv "NGINX_PORT" "8081";
  projectDir = getEnv "PROJECT_DIR" "";
  enableMysql = getEnv "ENABLE_MYSQL" "";
  mysqlPort = getEnv "MYSQL_PORT" "3306";
  memcachedPort = getEnv "MEMCACHED_PORT" "11211";

  databaseName = getEnv "DB_DATABASE" "laravel";
  mysqlSocketDir = getEnv "MYSQL_SOCKET_DIR" "";
  enableLaravelQueue = getEnv "LARAVEL_QUEUE" "";

  dataDir = getEnv "DATA_DIR" "/tmp/myfolder-${toString builtins.currentTime}";
in
{
  imports = [
    inputs.services-flake.processComposeModules.default
    (multiService ./extentions/php-fpm.nix)
    (multiService ./extentions/php-artisan-background.nix)
  ];

  services.nginx."nginx" = {
    enable = true;
    dataDir = dataDir + "/nginx";
    defaultMimeTypes = ''
      ${pkgs.nginx}/conf/mime.types
    '';
    eventsConfig = ''
      worker_connections 1024;
    '';
    httpConfig = #nginx
      ''
        server {
            listen ${nginxPort};
            server_name localhost;
            root "${projectDir}/public";

            index index.php index.html index.htm;

            location / {
                try_files $uri $uri/ /index.php$is_args$args;
            }

            location ~ \.php$ {
                fastcgi_pass 127.0.0.1:${phpFpmPort};
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include ${pkgs.nginx}/conf/fastcgi_params;
            }

            location ~ /\.ht {
                deny all;
            }
        }
      '';
  };


  services.php-fpm."phpFpm" = {
    enable = true;
    package = pkgs.php82;
    dataDir = dataDir + "/php";
    listen = builtins.fromJSON phpFpmPort;
    extraConfig = {
      "listen.owner" = "nobody";
      "listen.group" = "nobody";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };
  };

  services.mysql."php_mysql" = lib.mkIf (enableMysql != "")
    ({
      enable = true;
      dataDir = dataDir + "mysql";
      settings.mysqld.port = mysqlPort;
      initialDatabases = [
        { name = databaseName; }
      ];
    } // lib.optionalAttrs (mysqlSocketDir != "") {
      socketDir = mysqlSocketDir;
    });

  services.memcached."memcached" = {
    enable = true;
    port = builtins.fromJSON memcachedPort;
  };

  services.php-artisan-background."job1" = lib.mkIf (enableLaravelQueue != "") {
    enable = true;
    directoryWork = projectDir;
  };

}
