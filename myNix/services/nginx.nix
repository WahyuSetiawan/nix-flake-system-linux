{ inputs, pkgs, config, ... }:
let
  inherit (inputs.services-flake.lib) multiService;
  phpFpmPort =
    let
      phpfpmPort = builtins.getEnv "PHPFPM_PORT";
      port = if phpfpmPort == "" then "9000" else phpfpmPort;
    in
    port;
  nginxPort =
    let
      nginxPort = builtins.getEnv "NGINX_PORT";
      port = if nginxPort == "" then "8081" else nginxPort;
    in
    port;

  projectDir =
    let
      projectDir = builtins.getEnv "PROJECT_DIR";
      dir = if projectDir == "" then "" else projectDir;
    in
    dir;
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
              try_files \$uri \$uri/ /index.php?\$query_string;
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

  settings.processes.nginx.depends_on.phpFpm.condition = "process_completed_successfully";
}
