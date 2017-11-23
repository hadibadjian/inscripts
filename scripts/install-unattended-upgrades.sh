#!/usr/bin/env bash

sudo apt-get install -y unattended-upgrades

echo "
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"3\";
APT::Periodic::Unattended-Upgrade \"1\";

" | sudo tee /etc/apt/apt.conf.d/20auto-upgrades

systemctl restart unattended-upgrades.service
