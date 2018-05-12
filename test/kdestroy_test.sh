#!/usr/bin/env bash
#
# kdestroy_test.sh
#
# Execute kdestroy test in docker container context.

cd "$(dirname "$0")"
cd ..

container_name=${1:-krb5-machine-example-com}

docker exec ${container_name} /bin/bash -c '
  kdestroy
'

