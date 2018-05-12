#!/usr/bin/env bash
#
# dev_local_test.sh
#
# Test interaction with kerberos docker cluster via host machine directly.
#
# WARNING: This script creates resources on your host machine, execute that
# only if you know what you do.
# That Requires root permission. But do not run as root because some commands require
# be runned as normal user and use environment variables.

set -e

cd "$(dirname "$0")"
cd ../dev-local/ubuntu

source config.sh

yes | sed 's/y/Y/' | ./init_dev_env.sh
ssh -vvv bob@krb5-service-example-com.example.com hostname
