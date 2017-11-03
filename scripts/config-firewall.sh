#!/usr/bin/env bash

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow http
sudo ufw allow https
sudo ufw allow from 0.0.0.0/24 to any port 22
sudo ufw enable
