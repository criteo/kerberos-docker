#!/usr/bin/env bash
#
# install.sh
#
# Install environment for Continous Integration (CI) travis-ci.org.
# On Ubuntu 14.04.5 LTS (for the moment).

set -e

cd "$(dirname "$0")"
cd ..

sudo apt-get update

echo "=== Install python environment for generating configuration ==="
sudo apt-get -y install python3-pip python3-dev
sudo pip3 install virtualenv
python3 --version
pip3 --version
pip3 freeze
echo "...OK"

echo "=== Install bats for bash unit test ==="
mkdir -p tmp/
cd tmp/
wget "https://github.com/sstephenson/bats/archive/v0.4.0.zip" -O "bats-0.4.0.zip"
unzip -o bats-0.4.0.zip
cd bats-0.4.0/
sudo ./install.sh /usr/local
bats --version
echo "...OK"

echo "=== Install java and maven ==="
sudo add-apt-repository ppa:webupd8team/java -y
sudo add-apt-repository ppa:andrei-pozolotin/maven3 -y
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default
sudo apt-get install maven3
echo TODO
