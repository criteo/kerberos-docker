#!/usr/bin/env bash
#
# create-network.sh
#
# Create network example.com for bridge cluster.
#
# See network: docker network ls
# Remove network: docker network rm <network_name>=

cd "$(dirname "$0")"
cd ..

source .env.values

subnet="${NETWORK_CONTAINER}"
network_name="${DOMAIN_CONTAINER}"
gateway="$(echo ${NETWORK_CONTAINER} | cut -f1-3 -d'.').254"

docker network ls | awk '{print $2}' | grep ^${network_name}$  &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "Docker network '${network_name}' already exists!"
  exit 0
fi

docker network create \
  --driver=bridge \
  --subnet=${subnet} \
  --ip-range=${subnet} \
  --gateway=${gateway} \
  ${network_name}

echo "Docker network ${network_name} created!"
