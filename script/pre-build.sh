#!/usr/bin/env bash
#
# pre-build.sh
#
# Pre-Build docker images for kerberos cluster.

cd "$(dirname "$0")"
cd ..

if [[ ! -f .env.values ]]; then
    >&2 echo "ERROR: .env.values file is missing!"
    exit 1
fi
source .env.values

suffix_realm=$(echo "${REALM_KRB5}" | sed 's/\./-/g' | tr [:upper:] [:lower:])

image_name="minimal-${OS_CONTAINER}"
image_id=$(docker images "${image_name}" | sed 1d)

if [[ -n "${image_id}" ]]; then
  echo "Docker image '${image_name}' already exists!"
  exit 0
fi

# Build template minimal operating system for each container
echo "=== pre-build docker image 'minimal-${OS_CONTAINER}' ==="
docker build -t  "${image_name}" "./.build-${suffix_realm}/${PREFIX_KRB5}-${OS_CONTAINER}"
