{MYSQL_DIR,
MYSQL_PORT,
...}:
''

      [mysqld]
      datadir = ${MYSQL_DIR}/data
      socket = ${MYSQL_DIR}/socket/mysql.sock
      port = ${MYSQL_PORT}
      bind-address = 127.0.0.1
      log-error = ${MYSQL_DIR}/logs/error.log
      pid-file = ${MYSQL_DIR}/mysql.pid

      [client]
      socket = ${MYSQL_DIR}/socket/mysql.sock
      port = ${MYSQL_PORT}
''
