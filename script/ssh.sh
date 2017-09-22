#!/usr/bin/env bash
#
# ssh.sh
#
# Test interactive SSH connection with kerberos authentication through kerberos cluster.

# Arguments

user="${1:-bob}"
ssh_server="${2:-krb5-service.example.com}"

# Script (debug mode)

ssh_client="krb5-machine"
ssh_cmd="ssh -vvv ${user}@${ssh_server}"

docker exec -it -e KRB5_TRACE=/dev/stderr "${ssh_client}" ${ssh_cmd}
