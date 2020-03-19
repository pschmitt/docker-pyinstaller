#!/bin/bash -x

set -e

cd /app || exit 9

if [[ -n "$DEPS" ]]
then
  apt-get update
  apt-get install -y $DEPS
  rm -rf /var/lib/apt/lists/*
fi

REQUIREMENTS_FILE="${REQUIREMENTS_FILE:-requirements.txt}"

pip install -r "$REQUIREMENTS_FILE"

pyinstaller --clean -F "$@"

# vim set ft=bash et ts=2 sw=2 :
