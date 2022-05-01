#!/usr/bin/env bash
#
# docker_start.sh
#
# Start all docker containers.

docker start krb5-machine-example-com krb5-kdc-server-example-com krb5-service-example-com
while ! docker ps | awk '{print $2}' | sed 1d | grep -q krb5-machine-example-com; do
  sleep 1
done
while ! docker ps | awk '{print $2}' | sed 1d | grep -q krb5-kdc-server-example-com; do
  sleep 1
done
while ! docker ps | awk '{print $2}' | sed 1d | grep -q krb5-service-example-com; do
  sleep 1
done