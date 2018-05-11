#!/usr/bin/env bash
#
# init.sh
#
# Init docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

source .env.values

kdc_server_container="${PREFIX_KRB5}-kdc-server.$(echo "${REALM_KRB5}" | tr [:upper:] [:lower:])"
service_container="${PREFIX_KRB5}-service.$(echo "${REALM_KRB5}" | tr [:upper:] [:lower:])"
machine_container="${PREFIX_KRB5}-machine.$(echo "${REALM_KRB5}" | tr [:upper:] [:lower:])"

echo "=== Init ${kdc_server_container} docker container ==="
docker exec "${kdc_server_container}" /bin/bash -c "
# Create users alice as admin and bob as normal user
# and add principal for the service
cat << EOF  | kadmin.local
add_principal -pw alice \"alice/admin@${REALM_KRB5}\"
add_principal -pw bob \"bob@${REALM_KRB5}\"
add_principal -randkey \"host/krb5-service.${DOMAIN_CONTAINER}@${REALM_KRB5}\"
ktadd -k /etc/krb5-service.keytab -norandkey \"host/krb5-service.${DOMAIN_CONTAINER}@${REALM_KRB5}\"
ktadd -k /etc/bob.keytab -norandkey \"bob@${REALM_KRB5}\"
listprincs
quit
EOF
"

echo "=== Copy keytabs to ${service_container} and "${machine_container}" ==="
mkdir -vp ./tmp/
docker cp "${kdc_server_container}":/etc/krb5-service.keytab ./tmp/krb5-service.keytab
docker cp "${kdc_server_container}":/etc/bob.keytab ./tmp/bob.keytab
docker cp ./tmp/krb5-service.keytab "${service_container}":/etc/krb5.keytab
docker cp ./tmp/bob.keytab "${machine_container}":/etc/bob.keytab


echo "=== Init "${machine_container}" docker container ==="
docker exec "${machine_container}" /bin/bash -c "

die() {
  >&2 echo \"$1\"
  exit 1
}

echo '* Kerberos password authentication:'
until echo bob | kinit bob@${REALM_KRB5}; do
  echo Waiting for kerberos server started ...
  sleep 1
done

echo '* Kerberos keytab authentication:'
kinit -kt /etc/bob.keytab bob@${REALM_KRB5} && echo OK || die KO

echo '* Kerberos tickets cache:'
klist
"

echo "=== Init GSS API for Java Client/Server ==="
cd gssapi-java/

mvn --settings=settings.xml install -Dmaven.test.skip=true

docker cp gss-client/target/gss-client-1.0-SNAPSHOT-jar-with-dependencies.jar "${machine_container}":/root/client.jar
docker cp gss-client/config/jaas-krb5.conf "${machine_container}":/root/jaas-krb5.conf
docker cp gss-client/script/client-gss-java.sh "${machine_container}":/root/client-gss-java.sh

docker cp gss-server/target/gss-server-1.0-SNAPSHOT-jar-with-dependencies.jar "${service_container}":/root/server.jar
docker cp gss-server/config/jaas-krb5.conf "${service_container}":/root/jaas-krb5.conf
docker cp gss-server/script/server-gss-java.sh "${service_container}":/root/server-gss-java.sh
