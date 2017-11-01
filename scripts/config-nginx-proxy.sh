#!/usr/bin/env bash

UPSTREAM_URL='http://0.0.0.0'

vhost_conf="
limit_conn_zone \$binary_remote_addr zone=connperip:10m;
limit_conn_zone \$server_name zone=connperserver:10m;

limit_req_zone \$binary_remote_addr zone=reqperip:10m rate=1r/s;
limit_req_zone \$server_name zone=reqperserver:10m rate=10r/s;

server {
  listen 80 default_server;
  listen [::]:80 default_server;

  limit_conn connperip 10;
  limit_conn connperserver 100;

  limit_req zone=reqperip burst=5 nodelay;
  limit_req zone=reqperserver burst=10;

  server_name _;

  location / {
    proxy_pass ${UPSTREAM_URL};
  }
}

"

vhost_conf_file="/etc/nginx/sites-enabled/default"

echo "${vhost_conf_file}"
echo "${vhost_conf}" | sudo tee "${vhost_conf_file}"

sudo service nginx restart

echo "
WARN: Change the upstream URL ${UPSTREAM_URL}!
"
