#!/usr/bin/env bash
#
# init.sh
#
# Init docker containers for kerberos cluster.

echo "=== Init krb5-service docker container ==="
docker exec krb5-service /bin/bash -c '
echo -e "root\nroot" | passwd
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
listprincs
quit
EOF

# Send keytab to kerberized service
sshpass -p "root" \
  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
  /etc/krb5-service.keytab root@krb5-service.example.com:/etc/krb5.keytab
'

echo "=== Init krb5-machine docker container ==="
docker exec krb5-machine /bin/bash -c '
echo "bob" | kinit bob
klist
'
