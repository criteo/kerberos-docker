#!/usr/bin/env bash
#
# os_test.sh
#
# Test if operating system is correct on kerberos cluster of docker containers.

set -e

cd "$(dirname "$0")"
cd ..

source .env.values

container_name=${1:-krb5-machine-example-com}

docker exec -e OS_CONTAINER=${OS_CONTAINER} ${container_name} /bin/bash -c '
set -e

echo "Expected OS: ${OS_CONTAINER}"

if [[ ! -f /etc/os-release ]]; then
  >&2 echo "ERROR: unknown operating system for docker container!"
  exit 1
fi

source /etc/os-release
if [[ "$OS_CONTAINER" == "ubuntu" ]]; then
  if [[ "${ID}" == "ubuntu" ]] && [[ "${VERSION_ID}" == "16.04" ]]; then
    echo "OS: ${ID}:${VERSION_ID}"
    exit 0
  fi
elif [[ "$OS_CONTAINER" == "centos" ]]; then
  if [[ "${ID}" == "centos" ]] && [[ "${VERSION_ID}" == "7" ]]; then
    echo "OS: ${ID}:${VERSION_ID}"
    exit 0
  fi
fi

>&2 echo "ERROR: unknown operating system for docker container!"
exit 1
'
