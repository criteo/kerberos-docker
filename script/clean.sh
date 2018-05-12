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
if [[ -f docker-compose.yml ]]; then
  docker-compose -f docker-compose.yml rm --force
else
  >&2 echo "WARN: Can't remove cluster of containers, no docker-compose.yml file!"
fi

read -p "Do you want to remove services as docker images? [Y/n]: " \
answer
if [[ "${answer}" != "Y" ]]; then
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
if [[ "${answer}" != "Y" ]]; then
  exit 0
fi
echo "=== Remove example.com docker network ==="
network_id=$(docker network ls --filter "name=${DOMAIN_CONTAINER}" -q)
if [[ -z "${network_id}" ]]; then
  echo "No one network to remove"
else
  docker network rm ${network_id}
fi

read -p "Do you want to remove generated configuration "\
"(docker-compose.yml, .env.values and .project files)? [Y/n]: " \
answer
if [[ "${answer}" == "Y" ]]; then
  rm -v docker-compose.yml .env.values .project
fi

read -p "Do you want to remove all generated configuration"\
"in build folder? [Y/n]: " \
answer
if [[ "${answer}" == "Y" ]]; then
  rm -v $(git ls-files --others --ignored --exclude-standard ./build)
fi

read -p "Do you want to remove build folder? [Y/n]: " \
answer
if [[ "${answer}" == "Y" ]]; then
  rm -rv ".build-${suffix_realm}"
fi

echo "You must remove your minimal-<os> image at the hand, if you want..."
