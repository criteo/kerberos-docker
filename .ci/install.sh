#!/usr/bin/env bash
#
# install.sh
#
# Install environment for Continous Integration (CI) travis-ci.org.
# On Ubuntu 14.04.5 LTS (for the moment).

cd "$(dirname "$0")"
cd ..

echo "=== Install python environment for generating configuration ==="
sudo apt-get -y install python3-pip python3-dev
sudo pip3 install virtualenv
python3 --version
pip3 --version
pip3 freeze

echo "=== Install bats for bash unit test ==="
sudo add-apt-repository ppa:duggan/bats --yes
sudo apt-get update -qq
sudo apt-get install -qq bats
bats --version

echo "=== Install Kerberos environment in docker containers ==="
make install
