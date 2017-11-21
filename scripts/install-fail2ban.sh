#!/usr/bin/env bash

DESTEMAIL=user@example.com

if [[ "$DESTEMAIL" == "user@example.com" ]]; then
  echo 'Destination email not configured.'
  exit
fi

sudo apt install -y fail2ban

# ddos filter script
echo "
[Definition]
failregex = limiting requests, excess:.* by zone.*client:
ignoreregex =

" | sudo tee /etc/fail2ban/filter.d/nginx-ddos.conf

# ddos action script
echo "
[Definition]
actionstart =
actionstop =
actioncheck =
actionban = IP= &&
            printf %%b ": $IP\n" >>
actionunban = IP= && sed -i.old /ALL:\ $IP/d

[Init]
file = /etc/hosts.deny
daemon_list = ALL

" | sudo tee /etc/fail2ban/action.d/hostsdeny.conf

echo "
[DEFAULT]
bantime  = 3600

destemail = $DESTEMAIL

action = %(action_mwl)s

[sshd]
enabled = true

[sshd-ddos]
enabled = true

[nginx-http-auth]
enabled = true

[nginx-botsearch]
enabled = true

[nginx-ddos]
enabled   = true
port      = http,https
banaction = hostsdeny
findtime  = 120
bantime   = 7200
maxretry  = 30
logpath   = %(nginx_error_log)s
" | sudo tee /etc/fail2ban/jail.local
