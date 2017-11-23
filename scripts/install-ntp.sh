#!/usr/bin/env bash

sudo apt-get install -y ntp

sudo timedatectl set-timezone Australia/Melbourne

TIME_SERVERS=$(cat <<EOF
server 0.ubuntu.pool.ntp.org
server 1.ubuntu.pool.ntp.org
server 2.ubuntu.pool.ntp.org
server 3.ubuntu.pool.ntp.org
EOF
)

echo "${TIME_SERVERS}"  | sudo tee /etc/ntp.conf

sudo systemctl restart ntp.service
