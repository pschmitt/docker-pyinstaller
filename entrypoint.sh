#!/usr/bin/env bash

set -exo

cd /app || exit 9

if [[ -n "$DEPS" ]]
then
  apt-get update
  apt-get install -y $DEPS
  rm -rf /var/lib/apt/lists/*
fi

if [[ -n "$UPDATE_PIP" ]]
then
  pip install -U pip setuptools wheel
fi

REQUIREMENTS_FILE="${REQUIREMENTS_FILE:-requirements.txt}"

if [[ -e "$REQUIREMENTS_FILE" ]]
then
  pip install -r "$REQUIREMENTS_FILE"
else
  echo "No requirements file provided or $REQUIREMENTS_FILE does not exist" >&2
fi

# Install from setup.py or pyproject.toml unless SKIP_PIP_INSTALL_PROJECT is set
if [[ -z "$SKIP_PIP_INSTALL_PROJECT" ]] && \
   [[ -e setup.py || -e pyproject.toml ]]
then
  pip install .
fi

pyinstaller --clean -F "$@"
PYINSTALLER_RC="$?"

if [[ -n "$STATICX" ]]        || [[ -n "$STATICX_ARGS" ]] || \
   [[ -n "$STATICX_TARGET" ]] || [[ -n "$STATICX_OUTPUT" ]]
then
  DIST_FILES=(./dist/*)
  STATICX_TARGET="${STATIX_TARGET:-${DIST_FILES[0]}}"
  STATICX_OUTPUT="${STATICX_OUTPUT:-${STATICX_TARGET}_static}"
  STATICX_ARGS=($STATICX_ARGS)

  echo "Running staticx on $STATICX_TARGET (-> ${STATICX_OUTPUT})"
  rm -f "$STATICX_OUTPUT"
  staticx "${STATICX_ARGS[@]}" "$STATICX_TARGET" "${STATICX_OUTPUT}"
  chmod 755 "${STATICX_OUTPUT}"
else
  exit "$PYINSTALLER_RC"
fi

# vim set ft=bash et ts=2 sw=2 :
