#!/usr/bin/env bash

logrotate="
/var/vhosts/railsapp/current/log/*.log {
  copytruncate
  daily
  missingok
  rotate 14
  compress
  delaycompress
  notifempty
  dateext
  size 10M
  dateformat -${HOSTNAME}-%Y-%m-%d-%s
}

"

logrotate_conf_file='/etc/logrotate.d/railsapp'
echo "${logrotate_conf_file}"
if [ -f logrotate_conf_file ]; then
  sudo rm "${logrotate_conf_file}"
fi

echo "${logrotate}" | envsubst | sudo tee "${logrotate_conf_file}"
