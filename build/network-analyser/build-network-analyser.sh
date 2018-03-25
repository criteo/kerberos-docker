#!/usr/bin/env bash
#
# build-network-analyser.sh
#
# Start docker container from kerberos cluster to analyse network.

cd "$(dirname "$0")"

docker build -t network-analyser .
