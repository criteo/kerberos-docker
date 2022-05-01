#!/usr/bin/env bash
#
# kvno_test.sh
#
# Execute kvno test in docker container context.

cd "$(dirname "$0")" || exit 1

container_name="krb5-machine-example-com"

docker exec "${container_name}" /bin/bash -c '
  kvno host/krb5-service-example-com.example.com
'

