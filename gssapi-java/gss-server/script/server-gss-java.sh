#!/usr/bin/env bash
#
# server-gss-java.sh
#
# Run Generic Security Services (GSS) java server on port 4567.

cd "$(dirname "$0")"

java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=${PWD}/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar $@
