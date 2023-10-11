#!/usr/bin/env bash
#
# build-python-env.sh
#
# usage: source ./script/build-python-env.sh
# (call only from root repository)
#
# Build virtual python environment

echo "=== build python virtual environment ==="

\python3 -m venv ./.venv/
\source ./.venv/bin/activate
\pip3 install --upgrade pip
\pip3 install -r ./requirements.txt
\echo "Quit with deactivate command..."
