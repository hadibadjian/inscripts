#!/usr/bin/env bash

VERSION=2.4.1

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

rvm install ${VERSION}
rvm use ${VERSION} --default
ruby -v

rvm gemset use global
gem install bundler
