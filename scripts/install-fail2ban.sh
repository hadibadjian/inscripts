#!/usr/bin/env bash

sudo apt install -y fail2ban

# ddos filter script
sudo cp fail2ban/filter.d/nginx-ddos.conf /etc/fail2ban/filter.d/nginx-ddos.conf

sudo cp fail2ban/jail.local /etc/fail2ban/jail.local
