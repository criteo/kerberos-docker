#!/usr/bin/env bash
#
# clean-network-analyser.sh
#
# Clean docker containers and image from kerberos cluster to analyse network.

cd "$(dirname "$0")"


read -p "Do you want to remove containers from network-analyser image? [Y/n]: " answer;
if [[ "${answer}" == "Y" ]]; then
  container_ids=$(docker ps -aq --filter=ancestor=network-analyser)
  if [[ -n "${container_ids}" ]]; then
    docker stop "${container_ids}"
    docker rm "${container_ids}"
  else
    echo "No one container to remove"
  fi  
fi

read -p "Do you want to remove network-analyser image? [Y/n]: " answer;
if [[ "${answer}" == "Y" ]]; then
  image_id=$(docker images -q --filter=reference=network-analyser)
  if [[ -n "${image_id}" ]]; then
    docker rmi "${image_id}"
  else
    echo "No one image to remove"
  fi  
fi
