#!/usr/bin/env bash
#
# inspect.sh
#
# Inspect docker architecture for kerberos cluster.


services=$(docker-compose ps | cut -f1 -d ' ' | sed 1,2d)
# works because each service name matches with its container name 
for service in ${services}; do
  echo "=== Inspect service: ${service} ==="
  docker inspect "${service}"
done