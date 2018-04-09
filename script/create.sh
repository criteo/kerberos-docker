#!/usr/bin/env bash
#
# create.sh
#
# Create docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

services=$(docker-compose -f docker-compose.yml config --services)
for service in ${services}; do
  docker-compose -f docker-compose.yml create "${service}" &
done

wait
