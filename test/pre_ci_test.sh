#!/usr/bin/env bash
#
# pre_ci_test.sh
#
# Test script Travis CI before pushing.

cd "$(dirname "$0")"
cd ..

# check syntax Travis CI configuration
# gem install travis --no-rdoc --no-ri
# prerequisites Ruby 2.4+
travis lint .travis.yml

# check install (missing travis ci image)
#./.ci/install.sh
# check version
#./.ci/check-version.sh
