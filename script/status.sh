#!/usr/bin/env bash
#
# status.sh
#
# Show docker containers status for kerberos cluster.

cd "$(dirname "$0")"
cd ..

docker-compose ps

