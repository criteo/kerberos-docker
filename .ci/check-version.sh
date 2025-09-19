#!/usr/bin/env bash
#
# check-version.sh
#
# Check only interesting version after build

set -e

# Host machine
echo -e "*** HOST MACHINE ***\n"

echo "=== kernel version ==="
uname -sr

echo "=== os version ==="
cat /etc/issue

echo "=== Docker version ==="
docker --version

echo "=== Docker compose version ==="
docker compose version

echo "=== Docker info ==="
docker info

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

# Container
echo -e "\n*** CONTAINER ***\n"

echo "=== Container: kernel version ==="
docker exec krb5-machine-example-com uname -sr

echo "=== Container: OS version ==="
cat /etc/issue

echo "=== Container: MIT Kerberos version ==="
docker exec krb5-machine-example-com klist -V

