{ inputs, pkgs, config, lib, ... }:
let inherit (inputs.services-flake.lib) multiService;
  inherit (inputs.self.util) getEnv;

  projectName = getEnv "PROJECT_NAME" "default";

  phpFpmPort = getEnv "PHPFPM_PORT" "9000";
  nginxPort = getEnv "NGINX_PORT" "8082";
  projectDir = getEnv "PROJECT_DIR" "";

  postgresDbName = getEnv "POSTGRES_DB_NAME" "sample";
  portgresPort = getEnv "POSTGRES_PORT" "5432";
  postgresListen = getEnv "POSTGRES_LISTEN" "127.0.0.1";
  postgresSchema = getEnv "POSTGRES_SCHEMA" "";

  postgresUser = getEnv "POSTGRES_USER" "dev_user";
  postgresPass = getEnv "POSTGRES_PASS" "my_password";

  
  enableMysql = getEnv "ENABLE_MYSQL" "";
  mysqlPort = getEnv "MYSQL_PORT" "3306";
  memcachedPort = getEnv "MEMCACHED_PORT" "11211";

  databaseName = getEnv "DB_DATABASE" "laravel";
  mysqlSocketDir = getEnv "MYSQL_SOCKET_DIR" "";
  enableLaravelQueue = getEnv "LARAVEL_QUEUE" "";

  dataDir = getEnv "DATA_DIR" "/tmp/myfolder-asdfasdf";
in
{
  imports = [
    inputs.services-flake.processComposeModules.default
    (multiService ./extentions/php-fpm.nix)
    (multiService ./extentions/php-artisan-background.nix)
  ];

  services.postgres."pg-${projectName}" = {
    enable = true;
    # dataDir = dataDir + "/postgres-${projectName}";
    port = builtins.fromJSON portgresPort;
    initialScript.before = ''
      CREATE USER ${postgresUser} WITH password '${postgresPass}';
      CREATE EXTENSION system_stats;
    '';
    extensions = exts: [
      exts.system_stats
    ];
    initialDatabases = [
      ({
        name = postgresDbName;
      }
      // lib.optionalAttrs (postgresSchema != "") {
        schemas = [ postgresSchema ];
      }
      )
    ];
  };


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
            root "${projectDir}";

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
      "pm.max_children" = 10;
      "pm.start_servers" = 4;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 6;
      "php_admin_value[max_input_vars]" = 5000;
      "php_admin_value[post_max_size]" = "128M";
      "php_admin_value[upload_max_filesize]" = "128M";
      "php_admin_value[max_execution_time]" = 300;
      "php_admin_value[memory_limit]" = "512M";
      "php_admin_value[date.timezone]" = "Asia/Jakarta";
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
