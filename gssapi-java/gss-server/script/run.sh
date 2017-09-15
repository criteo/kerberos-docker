#!/usr/bin/env bash
#
# run.sh
#
# Run Generic Security Services (GSS) java server on port 4567.

cd "$(dirname "$0")"
cd ..

java \
-Dsun.security.krb5.debug=false \
-Djava.security.auth.login.config=${PWD}/config/jaas-krb5.conf \
-Djava.security.krb5.conf=/etc/krb5.conf \
-jar target/gss-server-1.0-SNAPSHOT-jar-with-dependencies.jar $@
