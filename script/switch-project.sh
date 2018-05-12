#!/usr/bin/env bash
#
# switch-project.sh
#
# usage: bash ./script/switch-project.sh
#
# Switch project if several projects are built

cd "$(dirname "$0")"
cd ..

projet_name="$1"
if [[ ! -d .build-${projet_name} ]]; then
  >&2 echo "ERROR: project '${projet_name}' doesn't exist!"
  exit 1
fi

echo "Switch to project ${projet_name}"
ln -sfv ".build-${projet_name}/.env.values" .env.values
ln -sfv ".build-${projet_name}/docker-compose.yml" docker-compose.yml
echo -n "${projet_name}" > .project 