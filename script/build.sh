#!/usr/bin/env bash
#
# build.sh
#
# Build docker images for kerberos cluster.

cd "$(dirname "$0")"
cd ..

# By default it is number of CPUs
n_processes=$(grep -c ^processor /proc/cpuinfo)
echo "max of processes:  ${n_processes}"

# Build each service in parallel instead of sequentially
services=$(docker-compose config --services)
for service in ${services}; do
  while [[ $(jobs -r | wc -l) -gt ${n_processes} ]]; do
    :
  done
  echo "=== build docker service '${service}' as image ==="
  docker-compose -f docker-compose.yml build "${service}" &
done

wait
