#!/usr/bin/env bash
#
# init_env_dev.sh
#
# Initialize environment of development.
#
# WARNING: Read README.md and this script before executing, this script creates
# resources on your host machine, execute that only if you know what you do.
# That Requires root permission. But do not run as root because some commands require
# be runned as normal user and use environment variables.
#
# Note:
# For executing this script without typing password and neither using root user,
# or not modifying sudoers file, you can use 'sudo -v' before executing it.
#

set -e

cd "$(dirname "$0")"

source config.sh

if [[ $(id -u) -eq 0 ]]; then
  >&2 echo "ERROR: don't run as root, but required root permission, current user '$(id)'"
  exit 1
fi

configure_file() {
  local _file="$1"
  local reg_exp="$2"
  output="$(grep -nC 3 -E "${reg_exp}" "${_file}")"
  if [[ $? -ne 0 ]]; then
    echo -n "yes"
    return
  fi
  >&2 echo -e "WARNING: The file '${_file}' seems already configured:\n${output}"
  read -p "Do you want configure anyway? [Y/n]: " answer
  if [[ "${answer}" == "Y" ]]; then
    echo -n "yes"
    return
  fi
  echo -n "no"
}

echo "* install kerberos client"
sudo apt-get install krb5-user

cd ../..
echo "* get keytab"
sudo cp -vi ./.build-example-com/bob.keytab "${KEYTAB}"
sudo chmod -v 600 "${KEYTAB}"
sudo chown -v "${USER}":"${USER}" "${KEYTAB}"

echo "* get conf"
sudo cp -vi ./.build-example-com/services/krb5/client/krb5.conf "${KRB5_CONFIG}"

echo "* update /etc/hosts"
if [[ ! -e /etc/hosts ]]; then
  sudo touch /etc/hosts
  echo "created /etc/hosts as root user"
fi

if [[ "$(configure_file /etc/hosts krb5-.*.example.com)" == "yes" ]]; then
  cat << EOF | sudo tee -a /etc/hosts

# Kerberos cluster
# IP FQDN hostname
10.5.0.1	krb5-machine-example-com.example.com krb5-machine-example-com
10.5.0.2	krb5-kdc-server-example-com.example.com krb5-kdc-server-example-com
10.5.0.3	krb5-service-example-com.example.com krb5-service-example-com
EOF
fi

echo "* update configuration ~/ssh/config"
if [[ ! -e ~/.ssh/config ]]; then
  mkdir -p ~/.ssh
  touch ~/.ssh/config
  echo "created ~/.ssh/config as ${USER} user"
fi

if [[ "$(configure_file ~/.ssh/config krb5-.*.example.com)" == "yes" ]]; then
  cat << EOF | tee -a ~/.ssh/config

# Kerberos service
Host krb5-service-example-com.example.com
  HostName krb5-service-example-com
  GSSAPIAuthentication yes
  GSSAPIDelegateCredentials yes
  # only because local test
  StrictHostKeyChecking no
EOF
fi
echo "* get ticket-granting ticket (TGT)"
if [[ -e "${KRB5CCNAME}" ]]; then
  read -p "Do you want overwrite existing credentials cache? [Y/n]: " answer
  if [[ "${answer}" == "Y" ]]; then
    kinit -Vkt "${KEYTAB}" bob@EXAMPLE.COM
  fi
else
  kinit -Vkt "${KEYTAB}" bob@EXAMPLE.COM
fi
klist

echo "Test '(source config.sh; ssh -vvv bob@krb5-service-example-com.example.com)' with Kerberos authentication..."
