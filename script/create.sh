#!/usr/bin/env bash
#
# create.sh
#
# Create docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

services=$(docker-compose config --services)
for service in ${services}; do
  docker-compose create "${service}" &
done

wait
