#!/usr/bin/env bash
#
# clean.sh
#
# Clean docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ ! -f .env.values ]]; then
    >&2 echo "ERROR: .env.values file is missing, do make gen-conf or make switch!"
    exit 1
fi
source .env.values

suffix_realm=$(echo "${REALM_KRB5}" | sed 's/\./-/g' | tr [:upper:] [:lower:])
build_id=$(echo "${OS_CONTAINER}-${REALM_KRB5}" | tr [:upper:] [:lower:])
build_name="build-${build_id}"

read -p "Do you want to remove virtual python environment "\
"(./.venv folder)? [Y/n]: " \
answer
if [[ "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  rm -v -rf ./.venv
fi

read -p "Do you want to remove services as docker containers? [Y/n]: " \
answer
if [[ ! "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  exit 0
fi
echo "=== Remove services as docker container ==="
if [[ -f docker-compose.yml ]]; then
  docker-compose -f docker-compose.yml rm --force
else
  >&2 echo "WARN: Can't remove cluster of containers, no docker-compose.yml file!"
fi

read -p "Do you want to remove services as docker images? [Y/n]: " \
answer
if [[ ! "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  exit 0
fi
echo "=== Remove services as docker image ==="
image_ids=$(docker images --filter "reference=${PREFIX_KRB5}-*-${suffix_realm}" -q)
if [[ -z "${image_ids}" ]]; then
  echo "No one image to remove"
else
  docker rmi --force ${image_ids}
fi

read -p "Do you want to remove services network? [Y/n]: " \
answer
if [[ ! "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  exit 0
fi
echo "=== Remove example.com docker network ==="
network_id=$(docker network ls --filter "name=${DOMAIN_CONTAINER}" -q)
if [[ -z "${network_id}" ]]; then
  echo "No one network to remove"
else
  docker network rm ${network_id}
fi

read -p "Do you want to remove generated configuration " \
"(docker-compose.yml, .env.values and .build files)? [Y/n]: " \
answer
if [[ "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  rm -v docker-compose.yml .env.values .build
fi

read -p "Do you want to remove build folder (./${build_name})? [Y/n]: " \
answer
if [[ "${answer}" =~ ^(Y|y|yes|)$ ]]; then
  rm -rv "./${build_name}"
fi

echo "You can remove your minimal-<os> and <os>:<version> docker images at the hand now, if you want..."
