#!/usr/bin/env bash
#
# inspect.sh
#
# Inspect docker architecture for kerberos cluster.


services=$(docker-compose -f docker-compose.yml config --services)
for service in ${services}; do
  echo "=== Inspect service: ${service} ==="
  container_id=$(docker-compose -f docker-compose.yml ps -q ${service})
  docker inspect "${container_id}"
done