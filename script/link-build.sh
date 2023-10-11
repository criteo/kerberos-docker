#!/usr/bin/env bash
#
# link-build.sh
#
# usage: source ./script/link-build.sh
#
# Link the folder containing configuration files used to build docker container

cd "$(dirname "$0")"
cd ..

if [[ ! -f .env.values ]]; then
    >&2 echo "ERROR: .env.values file is missing!"
    exit 1
fi
source .env.values

build_id=$(echo "${OS_CONTAINER}-${REALM_KRB5}" | tr [:upper:] [:lower:])
build_name="build-${build_id}"

mv -fv .env.values "./${build_name}/"

./script/switch-build.sh "${build_id}"


