#!/usr/bin/env bash
#
# start.sh
#
# Run docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ -f docker-compose.yml ]]; then
  docker-compose -f docker-compose.yml start
else
  >&2 echo "WARN: Can't start cluster of containers, no docker-compose.yml file!"
fi

