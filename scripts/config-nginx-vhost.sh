#!/usr/bin/env bash

# Create shared resources
sudo mkdir -p /var/vhosts/railsapp/shared/config
sudo chown -R ubuntu:ubuntu /var/vhosts/

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
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;

  # server_name_in_redirect off;
  server_names_hash_max_size 512;
  server_names_hash_bucket_size 128;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

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

vhost_conf="
limit_conn_zone \$binary_remote_addr zone=connperip:10m;
limit_conn_zone \$server_name zone=connperserver:10m;

limit_req_zone \$binary_remote_addr zone=reqperip:10m rate=1r/s;
limit_req_zone \$server_name zone=reqperserver:10m rate=10r/s;

upstream railsapp {
  server unix:/var/vhosts/puma.sock;
}

# Config for vhost
server {
  listen 80 default_server;

  limit_conn connperip 10;
  limit_conn connperserver 100;

  limit_req zone=reqperip burst=5 nodelay;
  limit_req zone=reqperserver burst=10;

  access_log /var/log/nginx/railsapp.access.log;
  error_log /var/log/nginx/railsapp.error.log;

  root /var/vhosts/railsapp/current/public;

  # assets caching
  location ~ ^/(assets)/ {
    access_log  off;
    gzip_static on;
    expires     max;
    add_header  Cache-Control public;
    add_header  Last-Modified \"\";
    add_header  ETag \"\";

    open_file_cache          max=1000 inactive=500s;
    open_file_cache_valid    600s;
    open_file_cache_errors   on;
    break;
  }

  # serve static file directly
  try_files \$uri @railsapp;

  # App proxying
  location @railsapp {
    proxy_redirect    off;
    proxy_set_header  Host \$host;
    proxy_set_header  X-Real-IP \$remote_addr;
    proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_pass        http://railsapp;
  }

  error_page 500 502 503 504 /500.html;
  keepalive_timeout 10;

  location = /favicon.ico {
    expires    max;
    add_header Cache-Control public;
  }
}

"

for i in 1 2; do echo ''; done
vhost_conf_file="/etc/nginx/sites-available/railsapp"
vhost_conf_sym_file="/etc/nginx/sites-enabled/railsapp"
if [ -f vhost_conf_file ]; then
  sudo rm "${vhost_conf_file}" "${vhost_conf_sym_file}"
fi

sudo rm '/etc/nginx/sites-enabled/default'

echo "${vhost_conf_file}"
echo "${vhost_conf}" | sudo tee "${vhost_conf_file}"
sudo ln -s "${vhost_conf_file}" "${vhost_conf_sym_file}"

sudo service nginx restart
