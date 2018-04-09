#!/usr/bin/env bash
#
# inspect.sh
#
# Inspect docker architecture for kerberos cluster.


services=$(docker-compose -f docker-compose.yml config --services)
# works because each service name matches with its container name 
for service in ${services}; do
  echo "=== Inspect service: ${service} ==="
  docker inspect "${service}"
done