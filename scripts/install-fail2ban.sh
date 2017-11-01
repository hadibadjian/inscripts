#!/usr/bin/env bash

sudo apt install -y fail2ban

ufw allow ssh
ufw enable -y
