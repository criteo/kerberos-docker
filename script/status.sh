#!/usr/bin/env bash
#
# status.sh
#
# Show docker containers status for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ -f docker-compose.yml ]]; then
  docker-compose ps
else
  >&2 echo "WARN: Can't see status cluster of containers, no docker-compose.yml file!"
fi

