#!/usr/bin/env bash
#
# gss_api_java_test.sh
#
# Execute unit tests in docker container context for gssapi-java project.

cd "$(dirname "$0")"
cd ..

container_name=${1:-krb5-machine-example-com}

docker exec ${container_name} /bin/bash -c '
  cd /root/share/gssapi-java/
  mvn --settings=settings.xml test
'
