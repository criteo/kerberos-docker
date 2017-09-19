#!/usr/bin/env bash
#
# gss_api_java_test.sh
#
# Test GSS API connection with Java Client/Server with kerberos authentication through kerberos cluster.

service=${1:-host}
server_name=${2:-krb5-service.example.com}
with_server=${3:-0}

if [[ ${with_server} ]]; then
  # Start server
  docker exec -d krb5-service bash -c "\
  java \
  -Dsun.security.krb5.debug=false \
  -Djava.security.auth.login.config=/root/jaas-krb5.conf \
  -Djava.security.krb5.conf=/etc/krb5.conf \
  -jar server.jar
  sleep 2
  "
fi

# Start client
docker exec krb5-machine bash -c "
java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=/root/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar client.jar "${service}" "${server_name}"
"
