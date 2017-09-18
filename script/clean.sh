#!/usr/bin/env bash
#
# clean.sh
#
# Clean docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

read -p "Do you want to remove virtual python environment "\
"(./env folder)? [Y/n]: " \
answer
if [[ "${answer}" == "Y" ]]; then
  rm -v -rf ./env
fi

read -p "Do you want to remove services as docker containers? [Y/n]: " \
answer
if [[ "${answer}" != "Y" ]]; then
  exit 0
fi
echo "=== Remove services as docker container ==="
docker-compose rm --force

read -p "Do you want to remove services as docker images? [Y/n]: " \
answer
if [[ "${answer}" != "Y" ]]; then
  exit 0
fi
echo "=== Remove services as docker image ==="
image_ids=$(docker images --filter "reference=krb5-*" -q)
if [[ -z "${image_ids}" ]]; then
  echo "No one image to remove"
else
  docker rmi ${image_ids}
fi

read -p "Do you want to remove services network? [Y/n]: " \
answer
if [[ "${answer}" != "Y" ]]; then
  exit 0
fi
echo "=== Remove example.com docker network ==="
network_id=$(docker network ls --filter "name=example.com" -q)
if [[ -z "${network_id}" ]]; then
  echo "No one network to remove"
else
  docker network rm ${network_id}
fi

read -p "Do you want to remove generated configuration "\
"(docker-compose.yml and .env.values files)? [Y/n]: " \
answer
if [[ "${answer}" == "Y" ]]; then
  rm -v docker-compose.yml .env.values
fi

echo "You must remove your minimal-<os> image at the hand, if you want..."
