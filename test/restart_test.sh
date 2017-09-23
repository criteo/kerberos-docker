#!/usr/bin/env bash
#
# restart_test.sh
#
# Test if each service is running in docker container after restarting
# with open port and ssh connection.

set -e

cd "$(dirname "$0")"
cd ..

is_open_port() {
  local ip="$1"
  local ports="$2"
  local type_port="${3:-tcp}"
  for port in ${ports}; do
     if [[ "${type_port}" = "udp" ]]; then
         local option="-u"
     fi
     nc ${option} -z -v -w2 "${ip}" "${port}"
     if [[ $? -ne 0 ]]; then
       return 1
    fi
  done
}

echo "=== restart status only on script ==="
make restart

echo "=== wait of each service started =="
sleep 5
echo "...OK"

echo "=== test udp/tcp open port ==="
# httpserver(s) tcp port
for i in 1 2 3; do
  is_open_port "10.5.0.$i" "500$i"
done

# kerberos server udp/tcp port
is_open_port 10.5.0.2 "88 464 749"
is_open_port 10.5.0.2 "88 464" udp

# ssh server tcp port
is_open_port 10.5.0.3 "22"

echo "=== test ssh connection ==="
./test/kinit_test.sh
./test/ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic'
