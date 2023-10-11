#!/usr/bin/env bash
#
# switch-build.sh
#
# usage: bash ./script/switch-build.sh
#
# Switch build if several projects are built

cd "$(dirname "$0")"
cd ..

build_id="$1"
if [[ ! -d ./build-${build_id} ]]; then
  >&2 echo "ERROR: folder './build-${build_id}' doesn't exist!"
  exit 1
fi

echo "==== switch to build ${build_id} ==="
ln -sfv "./build-${build_id}/.env.values" .env.values
ln -sfv "./build-${build_id}/docker-compose.yml" docker-compose.yml

echo "${build_id}" > ./.build