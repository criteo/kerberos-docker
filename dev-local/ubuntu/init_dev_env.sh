#!/usr/bin/env bash
#
# init_env_dev.sh
#
# Initialize environment of development.
#
# WARNING: Read README.md and this script before executing, this script creates
# resources on your host machine, execute that only if you know what you do.
# That Requires root permission. But do not run as root because some commands require
# be run as normal user and use environment variables.
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
    return 1
  fi
  >&2 echo -e "WARNING: The file '${_file}' seems already configured:"
  read -r -p "Do you want configure anyway? [Y/n]: " answer
  if [[ "${answer}" =~ ^(|y|Y)$ ]]; then
    return
  else
    >&2 echo "don't configure the file '${_file}'!"
    return 1
  fi
}

echo -e "\n* INSTALL KERBEROS CLIENT\n"
if ! apt list --installed |& grep -q krb5; then
  sudo apt-get install krb5-user
else
  echo "kerberos is already installed with 'krb5-user' package!"
fi

cd ../..
echo -e "\n* GET KERBEROS KEYTAB\n"
sudo cp -vi ./.build-example-com/bob.keytab "${KEYTAB}"
sudo chmod -v 600 "${KEYTAB}"
sudo chown -v "${USER}":"${USER}" "${KEYTAB}"

echo -e "\n* GET KERBEROS CONF\n"
sudo cp -vi ./.build-example-com/services/krb5/client/krb5.conf "${KRB5_CONFIG}"

echo -e "\n* UPDATE LOCAL DNS CONFIGURATION FOR KERBEROS: /etc/hosts\n"
if [[ ! -e /etc/hosts ]]; then
  sudo touch /etc/hosts
  echo "created /etc/hosts as root user"
fi

if configure_file /etc/hosts krb5-.*.example.com; then
  cat << EOF | sudo tee -a /etc/hosts

# Local Kerberos cluster
# IP FQDN hostname
10.5.0.1	krb5-machine-example-com.example.com krb5-machine-example-com
10.5.0.2	krb5-kdc-server-example-com.example.com krb5-kdc-server-example-com
10.5.0.3	krb5-service-example-com.example.com krb5-service-example-com
EOF
fi

echo -e "\n* UPDATE SSH CONFIGURATION FOR KERBEROS: ~/ssh/config\n"
if [[ ! -e ~/.ssh/config ]]; then
  mkdir -p ~/.ssh
  touch ~/.ssh/config
  echo "created ~/.ssh/config as ${USER} user"
fi

if configure_file ~/.ssh/config krb5-.*.example.com; then
  cat << EOF | tee -a ~/.ssh/config

# Local Kerberos service instance
Host krb5-service-example-com.example.com
  HostName krb5-service-example-com
  GSSAPIAuthentication yes
  GSSAPIDelegateCredentials yes
  # only because local test
  StrictHostKeyChecking no
EOF
fi

echo -e "\n* VIEW DEV AND LOCAL KERBEROS CONFIG\n"
read -r -p "Do you want to see dev and local Kerberos config? [Y/n]: " answer
if [[ "${answer}" =~ ^(|y|Y)$ ]]; then
  more /etc/krb5-dev.conf /etc/hosts ~/.ssh/config
  echo "::::::::::::::
Local Keytab for bob
::::::::::::::"
  klist -kte /etc/bob.keytab
  ls -al /etc/bob.keytab
  echo "::::::::::::::
MIT Kerberos version
::::::::::::::"
  klist -V
else
  echo "don't view dev and local Kerberos config!"
fi

echo -e "\n* GET A KERBEROS TICKET-GRANTING TICKET (TGT)\n"
read -r -p "Do you want to get a TGT? [Y/n]: " answer
if [[ "${answer}" =~ ^(|y|Y)$ ]]; then
  if [[ -e "${KRB5CCNAME}" ]]; then
    read -r -p "Do you want to overwrite existing credentials cache? [Y/n]: " answer
    if [[ "${answer}" =~ ^(|y|Y)$ ]]; then
      kinit -Vkt "${KEYTAB}" bob@EXAMPLE.COM
    fi
  else
    kinit -Vkt "${KEYTAB}" bob@EXAMPLE.COM
  fi
  klist
fi

echo -e "\nYou can now test your dev and local Kerberos config with '(source config.sh; ssh -vvv bob@krb5-service-example-com.example.com)' ..."
