#!/usr/bin/env bash
#
# install.sh
#
# Install environment for Continuous Integration (CI)

set -e

cd "$(dirname "$0")"
cd ..

sudo apt-get update

echo "=== Install python environment for generating configuration ==="
sudo apt -y install python3-pip python3-dev
python3 --version
pip3 --version
pip3 freeze
echo "...OK"

echo "=== Install bats for bash unit test ==="
sudo apt -y install bats
bats --version
echo "...OK"

#echo "=== Install java and maven ==="
#sudo add-apt-repository ppa:webupd8team/java -y
#sudo apt update
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
#sudo apt -y install oracle-java8-installer
#sudo apt -y install oracle-java8-set-default
#sudo apt install maven
#echo "...OK"
