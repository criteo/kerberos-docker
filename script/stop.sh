#!/usr/bin/env bash
#
# stop.sh
#
# Stop docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ -f docker-compose.yml ]]; then
  docker-compose stop
else
  >&2 echo "WARN: Can't stop cluster of containers, no docker-compose.yml file!"
fi
