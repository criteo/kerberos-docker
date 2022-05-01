#!/usr/bin/env bash
#
# make_test.sh
#
# Execute several targets of make.

cd "$(dirname "$0")/.." || exit 1

make usage status start stop restart stop status 
