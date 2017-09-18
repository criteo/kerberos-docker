#!/usr/bin/env bash
#
# kinit_test.sh
#
# Execute kinit tests in docker container context.

set -e

cd "$(dirname "$0")"

source config.sh

# Open tests
if [[ -f $LOG ]]; then
  rm -f $LOG
fi

trap 'echo "See $LOG for more details ..."' EXIT

./test.bats

# Close tests
# nothing to do
