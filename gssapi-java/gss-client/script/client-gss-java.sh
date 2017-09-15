#!/usr/bin/env bash
#
# client-gss-java.sh
#
# Run Generic Security Services (GSS) java client.

cd "$(dirname "$0")"

java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=${PWD}/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar $@
