#!/usr/bin/env bash

VERSION=2.4.1

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install -y rvm

source /etc/profile.d/rvm.sh

echo "
Requires a system restart on Ubuntu Server

  sudo reboot

INFO: Install required ruby version and set it as the default.

  rvm install \${VERSION}
  rvm use \${VERSION} --default
  ruby -v

INFO: Install bundler in the global gemset.

  rvm gemset use global
  gem install bundler
"
