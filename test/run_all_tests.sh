#!/usr/bin/env bash
#
# kinit_test.sh
#
# Execute kinit tests in docker container context.

cd "$(dirname "$0")"

source config.sh

# Open tests
if [[ -f $LOG ]]; then
  rm -f $LOG
fi

./test.bats

# Close tests
echo "See $LOG for more details ..."
