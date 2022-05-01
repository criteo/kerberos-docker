#!/usr/bin/env bash
#
# kdestroy_test.sh
#
# Execute kdestroy test in docker container context.

cd "$(dirname "$0")" || exit 1

container_name="krb5-machine-example-com"

docker exec "${container_name}" /bin/bash -c '
  kdestroy
'

