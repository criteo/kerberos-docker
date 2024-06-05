#!/usr/bin/env bash
#
# init.sh
#
# Init docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

source .env.values

suffix_realm=$(echo "${REALM_KRB5}" | sed 's/\./-/g' | tr [:upper:] [:lower:])
kdc_server_container="${PREFIX_KRB5}-kdc-server-${suffix_realm}"
service_container="${PREFIX_KRB5}-service-${suffix_realm}"
machine_container="${PREFIX_KRB5}-machine-${suffix_realm}"

echo "=== Init ${kdc_server_container} docker container ==="
docker exec "${kdc_server_container}" /bin/bash -c "
# add principal for the service
cat << EOF  | kadmin.local
add_principal -randkey \"postgres/${service_container}.${DOMAIN_CONTAINER}@${REALM_KRB5}\"
ktadd -k /etc/postgres-server-krb5.keytab -norandkey \"postgres/${service_container}.${DOMAIN_CONTAINER}@${REALM_KRB5}\"
listprincs
quit
EOF
"

echo "=== Copy keytabs to ${service_container} and "${machine_container}" ==="
tmp_folder="$(mktemp -d)"
docker cp "${kdc_server_container}":/etc/postgres-server-krb5.keytab "${tmp_folder}/postgres-server-krb5.keytab"
docker cp "${tmp_folder}/postgres-server-krb5.keytab" "${service_container}":/etc/postgres-server-krb5.keytab
docker cp "${tmp_folder}/postgres-server-krb5.keytab" "${machine_container}":/etc/postgres-server-krb5.keytab
rm -vrf "${tmp_folder}"


echo "=== Init "${machine_container}" docker container ==="
docker exec "${machine_container}" /bin/bash -c "

die() {
  >&2 echo \"$1\"
  exit 1
}

echo '* Kerberos keytab authentication:'
kinit -kt /etc/postgres-server-krb5.keytab postgres/${service_container}.${DOMAIN_CONTAINER} && echo OK || die KO

echo '* Kerberos tickets cache:'
klist
"

echo "=== Init "${service_container}" docker container ==="
docker exec "${service_container}" /bin/bash -c "

die() {
  >&2 echo \"$1\"
  exit 1
}

echo '* Give the keytab file read permission for postgres user:'
chown postgres:postgres /etc/postgres-server-krb5.keytab
chmod 600 /etc/postgres-server-krb5.keytab

echo '* Create new role for database:'
sleep 5
psql -U postgres -c 'CREATE ROLE \"postgres/${service_container}.${DOMAIN_CONTAINER}\" WITH LOGIN;'
"

#echo "=== Init GSS API for Java Client/Server ==="
#cd gssapi-java/
#
#mvn --settings=settings.xml install -Dmaven.test.skip=true
#
#docker cp gss-client/target/gss-client-1.0-SNAPSHOT-jar-with-dependencies.jar "${machine_container}":/root/client.jar
#docker cp gss-client/config/jaas-krb5.conf "${machine_container}":/root/jaas-krb5.conf
#docker cp gss-client/script/client-gss-java.sh "${machine_container}":/root/client-gss-java.sh

#docker cp gss-server/target/gss-server-1.0-SNAPSHOT-jar-with-dependencies.jar "${service_container}":/root/server.jar
#docker cp gss-server/config/jaas-krb5.conf "${service_container}":/root/jaas-krb5.conf
#docker cp gss-server/script/server-gss-java.sh "${service_container}":/root/server-gss-java.sh
