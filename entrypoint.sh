#!/usr/bin/env bash

set -euxo

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
PYINSTALLER_RC="$?"

if [[ -n "$STATICX" ]]        || [[ -n "$STATICX_ARGS" ]] || \
   [[ -n "$STATICX_TARGET" ]] || [[ -n "$STATICX_OUTPUT" ]]
then
  DIST_FILES=(./dist/*)
  STATICX_TARGET="${STATIX_TARGET:-${DIST_FILES[0]}}"
  STATICX_OUTPUT="${STATICX_OUTPUT:-${STATICX_TARGET}_static}"

  echo "Running staticx on $STATICX_TARGET (-> ${STATICX_OUTPUT})"
  rm -f "$STATICX_OUTPUT"
  staticx "${STATICX_ARGS[@]}" "$STATICX_TARGET" "${STATICX_OUTPUT}"
else
  exit "$PYINSTALLER_RC"
fi

# vim set ft=bash et ts=2 sw=2 :
