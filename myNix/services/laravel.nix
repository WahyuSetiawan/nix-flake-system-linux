{ inputs, pkgs, config, lib, ... }:
let inherit (inputs.services-flake.lib) multiService;

  getEnv = nameEnv: default:
    let
      valueEnv = builtins.getEnv nameEnv;
      value = if valueEnv == "" then default else valueEnv;
    in
    value;

  phpFpmPort = getEnv "PHPFPM_PORT" "9000";
  nginxPort = getEnv "NGINX_PORT" "8081";
  projectDir = getEnv "PROJECT_DIR" "";
  enableMysql = getEnv "ENABLE_MYSQL" "";
  mysqlPort = getEnv "MYSQL_PORT" "3306";

  databaseName = getEnv "DB_DATABASE" "laravel";
  mysqlSocketDir = getEnv "MYSQL_SOCKET_DIR" "";

in
{
  imports = [
    inputs.services-flake.processComposeModules.default
    (multiService ./extentions/php-fpm.nix)
  ];

  services.nginx."nginx" = builtins.trace "project dir ${projectDir}" {
    enable = true;
    defaultMimeTypes = ''
      ${pkgs.nginx}/conf/mime.types
    '';
    eventsConfig = ''
      worker_connections 1024;
    '';
    httpConfig = ''
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
      settings.mysqld.port = mysqlPort;
      initialDatabases = [
        { name = databaseName; }
      ];
    } // lib.optionalAttrs (mysqlSocketDir != "") {
      socketDir = mysqlSocketDir;
    });

}
