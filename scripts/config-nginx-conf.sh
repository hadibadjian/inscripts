#!/usr/bin/env bash

nginx_conf='
user www-data;
worker_processes auto;
pid /run/nginx.pid;

include /etc/nginx/modules-enabled/*.conf;

events {
  worker_connections 768;
  multi_accept on;
}

http {
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  keepalive_timeout 65;
  sendfile on;
  server_tokens off;
  tcp_nodelay on;
  tcp_nopush on;
  types_hash_max_size 2048;

  real_ip_header X-Forwarded-For;
  set_real_ip_from 192.168.255.0/24;

  # server_name_in_redirect off;
  server_names_hash_max_size 512;
  server_names_hash_bucket_size 128;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  gzip on;
  gzip_disable \"msie6\";
  gzip_http_version 1.1;
  gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}

'

for i in 1 2; do echo ''; done
nginx_conf_file='/etc/nginx/nginx.conf'

if [ -f nginx_conf_file ]; then
  sudo rm "${nginx_conf_file}"
fi

echo "${nginx_conf_file}"
echo "${nginx_conf}" | sudo tee "${nginx_conf_file}"

sudo systemctl restart nginx.service

