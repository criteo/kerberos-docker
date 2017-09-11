#!/usr/bin/env bash
#
# init.sh
#
# Init docker containers for kerberos cluster.

cd "$(dirname "$0")"
cd ..

echo "=== Init krb5-service docker container ==="
docker exec krb5-service /bin/bash -c '
echo -e "bob\nbob" | adduser bob --gecos ""
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
cat << EOF  | kadmin.local
addprinc -policy admin alice/admin
alice
alice
addprinc -policy user bob
bob
bob
addprinc -randkey host/krb5-service.example.com@EXAMPLE.COM
ktadd -k /etc/krb5-service.keytab host/krb5-service.example.com@EXAMPLE.COM
ktadd -k /etc/bob.keytab bob@EXAMPLE.COM
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
echo "bob" | kinit bob
kinit -kt /etc/bob.keytab bob@EXAMPLE.COM
klist
'

