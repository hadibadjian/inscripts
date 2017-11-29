#!/usr/bin/env bash

# Create shared resources
sudo mkdir -p /var/vhosts/railsapp/shared/config
sudo chown -R deploy:deploy /var/vhosts/

vhost_conf="
limit_conn_zone \$binary_remote_addr zone=connperip:10m;
limit_conn_zone \$server_name zone=connperserver:10m;

limit_req_zone \$binary_remote_addr zone=reqperip:10m rate=2r/s;
limit_req_zone \$server_name zone=reqperserver:10m rate=10r/s;

upstream railsapp {
  server unix:/var/vhosts/railsapp/shared/tmp/sockets/puma.socket;
}

# Config for vhost
server {
  listen 80 default_server;

  server_name example.com

  limit_conn connperip 10;
  limit_conn connperserver 100;

  limit_req zone=reqperip burst=5 nodelay;
  limit_req zone=reqperserver burst=10;

  root /var/vhosts/railsapp/current/public;

  # assets caching
  location /assets/ {
    access_log  off;
    gzip_static on;
    expires     max;
    add_header  Cache-Control public;

    open_file_cache          max=1000 inactive=500s;
    open_file_cache_valid    600s;
    open_file_cache_errors   on;
  }

  # serve static file directly
  try_files \$uri @railsapp;

  # App proxying
  location @railsapp {
    proxy_redirect    off;
    proxy_set_header  Host \$host;
    proxy_set_header  X-Real-IP \$remote_addr;
    proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;

    proxy_set_header  X-Forwarded-For $scheme;

    if (\$http_x_forwarded_proto = \"http\") {
      rewrite  ^/(.*)$  https://example.com/\$1 permanent;
    }

    proxy_pass        http://railsapp;
  }

  error_page 500 502 503 504 /500.html;
  keepalive_timeout 10;
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

echo "
Make sure to change example.com in the server_name and protocol redirect clause.

  server_name example.com

  rewrite  ^/(.*)$  https://example.com/\$1 permanent;

Restart nginx for the changes to take place:

  sudo systemctl restart nginx.service
"
