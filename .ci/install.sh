#!/usr/bin/env bash
#
# install.sh
#
# Install environment for Continous Integration (CI) travis-ci.org.
# On Ubuntu 14.04.5 LTS (for the moment).

set -e

cd "$(dirname "$0")"
cd ..

echo "=== Install python environment for generating configuration ==="
sudo apt-get -y install python3-pip python3-dev
sudo pip3 install virtualenv
python3 --version
pip3 --version
pip3 freeze

echo "=== Install bats for bash unit test ==="
mkdir -p tmp/
cd tmp/
wget "https://github.com/sstephenson/bats/archive/v0.4.0.zip" -O "bats-0.4.0.zip"
unzip -o bats-0.4.0.zip
cd bats-0.4.0/
sudo ./install.sh /usr/local
bats --version
cd ../../

echo "=== Install Kerberos environment in docker containers ==="
make install
