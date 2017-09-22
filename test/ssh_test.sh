#!/usr/bin/env bash
#
# ssh_test.sh
#
# Test SSH connection with kerberos authentication through kerberos cluster.

user="${1:-bob}"
ssh_server="${2:-krb5-service.example.com}"
ssh_option="${3:--o PreferredAuthentications=gssapi-with-mic}"
docker_option="$4"
cmd=${5:-hostname}

ssh_cmd="ssh -vvv ${ssh_option} ${user}@${ssh_server} ${cmd}"
ssh_client="krb5-machine"

echo "=== test '${ssh_cmd}' from '${ssh_client}' container ===="

output=$(timeout 2s docker exec -e KRB5_TRACE=/dev/stderr ${docker_option} "${ssh_client}" ${ssh_cmd})
exit_status=$?

if [[ ${exit_status} -eq 124 ]]; then
  >&2 echo "${output}"
  >&2 echo "ERROR: time out too long command more than 2 seconds!"
  exit ${exit_status}
fi

if [[ ${exit_status} -eq 255 ]]; then
  >&2 echo "${output}"
  >&2 echo "ERROR: error occurred during SSH connection!"
  exit ${exit_status}
fi

if [[ ${exit_status} -ne 0 ]]; then
  >&2 echo "${output}"
  >&2 echo "ERROR: command passed to SSH connection failed!"
  exit ${exit_status}
fi

if [[ "${output}" != "${ssh_server}" ]]; then
  >&2 echo "ERROR: hostname ${output} is incorrect!"
  exit 1 
fi

echo "${output}"
echo "...OK"
