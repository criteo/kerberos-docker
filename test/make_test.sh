#!/usr/bin/env bash
#
# make_test.sh
#
# Execute several targets of make.

cd "$(dirname "$0")"
cd ..

make usage status start stop restart stop status 
