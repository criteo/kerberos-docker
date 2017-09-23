#!/usr/bin/env bash
#
# dev_local_test.sh
#
# Test interaction with kerberos docker cluster via host machine directly.
#
# WARNING: This script creates resources on your host machine, execute that 
# only if you know what you do. 
# Required root permission.

set -e

cd "$(dirname "$0")"
cd ../dev-local/ubuntu

yes | sed 's/y/Y/' | ./init_dev_env.sh
source config.sh
ssh -vvv bob@krb5-service.example.com hostname
