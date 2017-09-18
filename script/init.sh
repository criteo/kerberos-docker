#!/usr/bin/env bash
#
# init.sh
#
# Init docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

echo "=== Init krb5-service docker container ==="
docker exec krb5-service /bin/bash -c '
echo -e "pwd\npwd" | adduser bob --gecos ""
/usr/sbin/sshd -f /etc/ssh/sshd_config
ps -e | grep sshd
'

echo "=== Init krb5-kdc-server docker container ==="
docker exec krb5-kdc-server /bin/bash -c '
# Choose password krb5 for kerberos admin server
# Start server
echo -e "krb5\nkrb5" | krb5_newrealm
service krb5-admin-server start

# Create users alice as admin and bob as normal user
# and add principal for the service
mkdir -pv /var/log/kerberos/
touch /var/log/kerberos/kadmin.log
cat << EOF  | kadmin.local
add_principal -pw alice alice/admin@EXAMPLE.COM
add_principal -pw bob bob@EXAMPLE.COM
add_principal -randkey host/krb5-service.example.com@EXAMPLE.COM
ktadd -k /etc/krb5-service.keytab -norandkey host/krb5-service.example.com@EXAMPLE.COM
ktadd -k /etc/bob.keytab -norandkey bob@EXAMPLE.COM
listprincs
quit
EOF
'

echo "=== Copy keytabs to krb5-service and krb5-machine ==="
mkdir -vp ./tmp/
docker cp krb5-kdc-server:/etc/krb5-service.keytab ./tmp/krb5-service.keytab
docker cp krb5-kdc-server:/etc/bob.keytab ./tmp/bob.keytab
docker cp ./tmp/krb5-service.keytab krb5-service:/etc/krb5.keytab
docker cp ./tmp/bob.keytab krb5-machine:/etc/bob.keytab


echo "=== Init krb5-machine docker container ==="
docker exec krb5-machine /bin/bash -c '

die() {
  >&2 echo "$1"
  exit 1
}

echo -en "* Kerberos password authentication:\n..."
echo "bob" | kinit bob@EXAMPLE.COM && echo "OK" || die "KO"

echo -en "* Kerberos keytab authentication:\n..."
kinit -kt /etc/bob.keytab bob@EXAMPLE.COM && echo "OK" || die "KO"

echo "* Kerberos tickets cache:"
klist
'

echo "=== Init GSS API for Java Client/Server ==="
cd gssapi-java

mvn --settings=settings.xml install -Dmaven.test.skip=true

docker cp gss-client/target/gss-client-1.0-SNAPSHOT-jar-with-dependencies.jar krb5-machine:/root/client.jar
docker cp gss-client/config/jaas-krb5.conf krb5-machine:/root/jaas-krb5.conf
docker cp gss-client/script/client-gss-java.sh krb5-machine:/root/client-gss-java.sh

docker cp gss-server/target/gss-server-1.0-SNAPSHOT-jar-with-dependencies.jar krb5-service:/root/server.jar
docker cp gss-server/config/jaas-krb5.conf krb5-service:/root/jaas-krb5.conf
docker cp gss-server/script/server-gss-java.sh krb5-service:/root/server-gss-java.sh
