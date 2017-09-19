#!/usr/bin/env bash
#
# init_env_dev.sh
#
# Initialize environment of development.

set -e

cd "$(dirname "$0")"

source config.sh

echo "* install kerberos client"
sudo apt-get install krb5-user
echo "* get keytab"
sudo cp -vi ../../tmp/bob.keytab "${KEYTAB}"
sudo chmod -v 600 "${KEYTAB}"
sudo chown -v "${USER}":"${USER}" "${KEYTAB}"
echo "* get conf"
sudo cp -vi ../../krb5-ubuntu/machine/krb-conf/client/krb5.conf "${KRB5_CONFIG}"
echo "* update /etc/hosts"
if [[ ! -e /etc/hosts ]]; then
  sudo touch /etc/hosts
fi
cat << EOF | sudo tee -a /etc/hosts

# Kerberos cluster
10.5.0.1	krb5-machine.example.com krb5-machine
10.5.0.2	krb5-kdc-server.example.com krb5-kdc-server
10.5.0.3	krb5-service.example.com krb5-service
EOF
echo "* update configuration ~/ssh/config"
if [[ ! -e ~/.ssh/config ]]; then
  touch ~/.ssh/config
fi
cat << EOF | tee -a ~/.ssh/config

# Kerberos service
Host krb5-service.example.com
  HostName krb5-service.example.com
  GSSAPIAuthentication yes
  GSSAPIDelegateCredentials yes
EOF
echo "* get ticket-granting ticket (TGT)"
kinit -kt "${KEYTAB}" bob@EXAMPLE.COM
klist

echo "Test 'ssh -vvv bob@krb5-service.example.com' with Kerberos authentication..."
