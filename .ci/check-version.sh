#!/usr/bin/env bash

echo "=== os version ==="
cat /etc/issue

echo "=== docker version ==="
docker --version

echo "=== docker-compose version ==="
docker-compose --version

echo "=== MIT Kerberos version ==="
docker exec krb5-machine klist -V

echo "=== make version ==="
make --version

echo "=== bats version ==="
bats --version

echo "=== resolv.conf ==="
docker exec krb5-machine cat /etc/resolv.conf 

