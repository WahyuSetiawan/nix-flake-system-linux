{ PHP_PORT ? 9000, ... }: ''
  [global]
  pid = /tmp/php-fpm.pid
  error_log = /tmp/php-fpm.log
  daemonize = no

  [www]
  listen = 127.0.0.1:${toString PHP_PORT}
  listen.owner = nobody
  listen.group = nobody
  pm = dynamic
  pm.max_children = 5
  pm.start_servers = 2
  pm.min_spare_servers = 1
  pm.max_spare_servers = 3
''
