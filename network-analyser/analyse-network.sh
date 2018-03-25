#!/usr/bin/env bash
#
# analyse-network.sh
#
# Start docker container from kerberos cluster to analyse network.

cd "$(dirname "$0")"

docker run -it \
  --net=host --privileged \
  -v $HOME:/root/:rw \
  -u root \
  -e XAUTHORITY=/root/.Xauthority -e DISPLAY=${DISPLAY} \
  network-analyser $@
