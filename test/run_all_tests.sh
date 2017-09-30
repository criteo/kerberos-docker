#!/usr/bin/env bash
#
# run_all_tests.sh
#
# Run all unit tests and integration test.

set -e

cd "$(dirname "$0")"

source config.sh

if [[ -f $LOG ]]; then
  rm -f $LOG
fi

trap 'echo "See $LOG for more details ..."' EXIT

./test.bats --tap

