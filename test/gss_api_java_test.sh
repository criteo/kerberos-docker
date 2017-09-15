#!/usr/bin/env bash
#
# gss_api_java_test.sh
#
# Test GSS API connection with Java Client/Server with kerberos authentication through kerberos cluster.

service=${1:-host}
server_name=${2:-krb5-service.example.com}

# Start server
docker exec krb5-service \
java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=/root/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar server.jar &

sleep 2

# Start client
docker exec krb5-machine \
java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=/root/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar client.jar "${service}" "${server_name}"
