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

DIST_PATH="$(realpath -q "${DIST_PATH:-./dist}")"
if [[ -n "$CLEAN" ]]
then
  rm -rf ./build *.spec "$DIST_PATH"
fi

pyinstaller --clean --onefile --noconfirm --distpath "$DIST_PATH" "$@"
PYINSTALLER_RC="$?"

if [[ -n "$OWNER" ]]
then
  chown -R "$OWNER" "$DIST_PATH"
fi

if [[ -n "$CLEAN" ]]
then
  rm -rf ./build *.spec
fi

if [[ -n "$STATICX" ]]        || [[ -n "$STATICX_ARGS" ]] || \
   [[ -n "$STATICX_TARGET" ]] || [[ -n "$STATICX_OUTPUT" ]]
then
  DIST_FILES=("${DIST_PATH:-./dist}"/*)
  STATICX_TARGET="${STATIX_TARGET:-$(realpath -q ${DIST_FILES[0]})}"
  STATICX_OUTPUT="${STATICX_OUTPUT:-${STATICX_TARGET}_static}"
  STATICX_ARGS=($STATICX_ARGS)

  echo "Running staticx on $STATICX_TARGET (-> ${STATICX_OUTPUT})"
  rm -f "$STATICX_OUTPUT"

  staticx "${STATICX_ARGS[@]}" "$STATICX_TARGET" "${STATICX_OUTPUT}"
  STATICX_RC="$?"

  chmod 755 "${STATICX_OUTPUT}"
  if [[ -n "$OWNER" ]]
  then
    chown "$OWNER" "${STATICX_OUTPUT}"
  fi
  exit "$STATICX_RC"
fi

exit "$PYINSTALLER_RC"

# vim set ft=bash et ts=2 sw=2 :
