#!/usr/bin/env bash

DESTEMAIL=user@example.com

if [[ "$DESTEMAIL" == "user@example.com" ]]; then
  echo 'Destination email not configured.'
  exit
fi

sudo apt install -y fail2ban

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
" | sudo tee /etc/fail2ban/jail.local
