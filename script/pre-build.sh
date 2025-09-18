#!/usr/bin/env bash
#
# pre-build.sh
#
# Pre-Build docker images for kerberos cluster.

cd "$(dirname "$0")/.."

if [[ "${DEBUG}" == "true" ]]; then
  set -x
fi

if [[ ! -f .env.values ]]; then
    >&2 echo "ERROR: .env.values file is missing!"
    exit 1
fi
source .env.values

build_id=$(echo "${OS_CONTAINER}-${REALM_KRB5}" | tr [:upper:] [:lower:])
build_name="build-${build_id}"

image_name="minimal-${OS_CONTAINER}"
image_id=$(docker images "${image_name}" | sed 1d)

if [[ -n "${image_id}" ]]; then
  echo "Docker image '${image_name}' already exists!"
  exit 0
fi

# Build template minimal operating system for each container
echo "=== pre-build docker image '${image_name}:latest' ==="
docker build -t "${image_name}:latest" "./${build_name}/${PREFIX_KRB5}-${OS_CONTAINER}"
