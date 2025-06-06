{ pkgs
, LOGS_DIR
, NGINX_DIR
, NGINX_PORT ? 8080
, PROJECT_NAME ? "laravel"
, PROJECT_DIR
, ...
}:

''
  worker_processes 1;
  error_log ${LOGS_DIR}/nginx_error.log;
  pid ${NGINX_DIR}/nginx.pid;

  events {
      worker_connections 1024;
  }

  http {
      include ${pkgs.nginx}/conf/mime.types;
      default_type application/octet-stream;

      access_log ${LOGS_DIR}/nginx_access.log;

      client_body_temp_path ${NGINX_DIR}/temp/client_body;
      proxy_temp_path ${NGINX_DIR}/temp/proxy;
      fastcgi_temp_path ${NGINX_DIR}/temp/fastcgi;
      uwsgi_temp_path ${NGINX_DIR}/temp/uwsgi;
      scgi_temp_path ${NGINX_DIR}/temp/scgi;

      server {
          listen ${toString NGINX_PORT};
          server_name localhost ${PROJECT_NAME}.local;
          root ${PROJECT_DIR}/public;

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

''
