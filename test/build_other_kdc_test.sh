#!/usr/bin/env bash
#
# build_other_kdc_test.sh
#
# Build other kdc with other realm

cd "$(dirname "$0")"
cd ..

NETWORK_CONTAINER=10.6.0.0 REALM_KRB5=INSTANCE.COM DOMAIN_CONTAINER=instance.com make install