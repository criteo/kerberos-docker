#!/usr/bin/env bash
#
# stop.sh
#
# Stop docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

docker-compose stop
