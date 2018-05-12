#!/usr/bin/env bash
#
# create-build-folder.sh
#
# usage: source ./script/create-build-folder.sh
#
# Build folder containing configuration files used to build docker container

cd "$(dirname "$0")"
cd ..

if [[ ! -f .env.values ]]; then
    >&2 echo "ERROR: .env.values file is missing!"
    exit 1
fi
source .env.values

suffix_realm=$(echo "${REALM_KRB5}" | sed 's/\./-/g' | tr [:upper:] [:lower:])

cd build/
folders=$(find . -mindepth 1 -type d)
build_folder=$(pwd)
relative_path_files=$(find . -type f ! -name "*.template")

cd ..
echo "working directory: ${PWD}"
mkdir -pv ".build-${suffix_realm}/"
cp -fv .env.values ".build-${suffix_realm}/"
cp -fv docker-compose.yml ".build-${suffix_realm}/"
./script/switch-project.sh "${suffix_realm}"

cd ".build-${suffix_realm}/"
echo "working directory: ${PWD}"
mkdir -pv ${folders}
for file in ${relative_path_files}; do
    cp -fv "${build_folder}/${file}" "${file}"
done

