#!/usr/bin/env bash
#
# check-version.sh
#
# Check only interesting version after build

set -e

echo "=== os version ==="
cat /etc/issue

echo "=== kernel version ==="
uname -sr

echo "=== make version ==="
make --version

echo "=== bats version ==="
bats --version

echo "=== java version ==="
java -version

echo "=== maven version ==="
mvn --version

echo "=== python3 version ==="
python3 --version

echo "=== pip3 version ==="
pip3 --version

echo "=== python virtualenv version ==="
virtualenv --version

echo "=== docker version ==="
docker --version

echo "=== docker-compose version ==="
docker-compose --version

echo "=== docker info ==="
docker info

echo "=== MIT Kerberos version ==="
docker exec krb5-machine klist -V
