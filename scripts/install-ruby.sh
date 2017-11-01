#!/usr/bin/env bash

VERSION=2.4.0

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ${VERSION}
rvm use ${VERSION} --default
ruby -v

rvm gemset use global
gem install bundler
