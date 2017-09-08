#!/usr/bin/env bash
#
# create-network.sh
#
# Create network example.com for bridge cluster.
#
# See network: docker network ls
# Remove network: docker network rm <network_name>=

network_name="example.com"

docker network ls | awk '{print $2}' | grep ^${network_name}$  &> /dev/null
if [[ $? -eq 0 ]]; then
  echo "Docker network '${network_name}' already exists!"
  exit 0
fi

docker network create \
  --driver=bridge \
  --subnet=10.5.0.0/16 \
  --ip-range=10.5.0.0/24 \
  --gateway=10.5.0.254 \
  ${network_name}

echo "Docker network ${network_name} created!"
