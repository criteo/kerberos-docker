#!/usr/bin/env bash
#
# status.sh
#
# Show docker containers status for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ ! -f .project ]]; then
  >&2 echo "ERROR: Can't see status cluster of containers, no .project file, do make gen-conf or make switch!"
  exit 1
fi

if [[ ! -f docker-compose.yml ]]; then
  >&2 echo "ERROR: Can't see status cluster of containers, no docker-compose.yml file, do make gen-conf or make switch!"
  exit 1
fi

echo "Project: $(cat .project)"
docker-compose -f docker-compose.yml ps

