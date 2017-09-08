#!/usr/bin/env bash
#
# install.sh
#
# Install for Continous Integration (CI) travis-ci.org.

sudo add-apt-repository ppa:duggan/bats --yes
sudo apt-get update -qq
sudo apt-get install -qq bats
make install
