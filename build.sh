#!/usr/bin/env bash

DEFAULT_IMAGE_NAME=pschmitt/pyinstaller

usage() {
  echo "Usage: $0 [PYTHON_VERSION]"
}

array_join() {
  local IFS="$1"
  shift
  echo "$*"
}

get_available_architectures() {
  local image="$1"
  local tag="${2:-latest}"

  docker buildx imagetools inspect --raw "${image}:${tag}" | \
    jq -r '.manifests[].platform | .os + "/" + .architecture + "/" + .variant' | \
    sed 's#/$##' | sort | \
    grep -vE "windows|linux/arm/v5"  # remove unsupported
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  set -ex

  cd "$(readlink -f "$(dirname "$0")")" || exit 9

  # Defaults
  DOCKERFILE="${DOCKERFILE:-Dockerfile}"
  IMAGE_NAME="${IMAGE_NAME:-${DEFAULT_IMAGE_NAME}}"
  BASE_TAG="${BASE_TAG:-3.7-buster}"
  TAG="${TAG:-latest}"

  case "$1" in
    help|h|--help|-h)
      usage
      exit 0
      ;;
    2.7|2)
      TAG=2.7
      BASE_TAG=2.7-stretch
      ;;
    3.7|3)
      TAG=3.7
      BASE_TAG=3.7-buster
      ;;
    3.8)
      TAG=3.8
      BASE_TAG=3.8-buster
      ;;
  esac

  EXTRA_BUILD_ARGS=("--build-arg=BASE_TAG=${BASE_TAG}")

  case "$1" in
    push|p|--push|-p)
      EXTRA_BUILD_ARGS+=("--push")
      ;;
    *)
      EXTRA_BUILD_ARGS+=("--load")
      ;;
  esac

  read -r base_image <<< \
    "$(sed -nr 's/^FROM\s+([^:]+)(:.*)?/\1/p' "$DOCKERFILE" | head -1)"
  # shellcheck disable=2207
  platforms=($(get_available_architectures "$base_image" "$BASE_TAG"))

  BUILD_TYPE=manual

  if [[ "$TRAVIS" == "true" ]]
  then
    BUILD_TYPE=travis
    EXTRA_BUILD_ARGS+=("--no-cache")
  elif [[ "$GITHUB_ACTIONS" == "true" ]]
  then
    BUILD_TYPE=github
    EXTRA_BUILD_ARGS+=("--no-cache")
  fi

  docker buildx build \
    --file "$DOCKERFILE" \
    --platform "$(array_join "," "${platforms[@]}")" \
    --label=built-by=pschmitt \
    --label=build-type="$BUILD_TYPE" \
    --label=built-on="$HOSTNAME" \
    --tag "${IMAGE_NAME}:${TAG}" \
    "${EXTRA_BUILD_ARGS[@]}" \
    .
fi
