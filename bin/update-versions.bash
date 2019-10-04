#!/usr/bin/env bash
# vim: ft=sh

declare help="
Update script for deb-devel's docker versions.

Usage:
  update-versions.bash run
  update-versions.bash --version
  update-versions.bash -h | --help

Options:
  -h --help           Show this screen.
  --version           Show versions.
"

declare version="
Version: 1.0.0.
Licensed under the MIT terms.
"

declare OS
OS="$(uname -s)"

declare BASE_DIR="${BASE_DIR:-base}"
declare VERSIONS_BASE="${VERSIONS_BASE:-versions/base}"
source "$VERSIONS_BASE"

declare REGISTRY_BASE="${REGISTRY_BASE:-resnullius}"

mkbasecp() {
  local OUT_DIR="versions/$1/$2"
  mkdir -p "$OUT_DIR"
  cp -r "$BASE_DIR"/* "$OUT_DIR"
  mv "$OUT_DIR"/Dockerfile.base "$OUT_DIR"/Dockerfile
}

update_from() {
  cp "versions/$1/$2/Dockerfile" "tmp-dockerfile"
  sed -e "s/FROM.*/FROM $3/" "tmp-dockerfile" > "versions/$1/$2/Dockerfile"
  rm "tmp-dockerfile"
}

create_tag() {
  echo "export TAGS=($REGISTRY_BASE/$3-devel:$4)" > "versions/$1/$2/options"
}

run_updater() {
  for arch in "${ARCHS[@]}"; do
    rm -rf versions/"$arch"
    for version in "${VERSIONS[@]}"; do
      local name
      local distro
      local tag
      name=$(echo "$version" | sed -e 's/:/-/')
      distro=$(echo "$version" | sed -e 's/:.*//')
      tag=$(echo "$version" | sed -e 's/.*://')
      mkbasecp "$arch" "$name"
      update_from "$arch" "$name" "$version"
      create_tag "$arch" "$name" "$distro" "$tag"
    done
  done
}

version() {
  echo "$version"
}

help() {
  echo "$help"
}

main() {
  set -eo pipefail; [[ "$TRACE" ]] && set -x
  declare cmd="$1"
  case "$cmd" in
    run)          shift; run_updater "$@";;
    -h|--help)    shift; help "$@";;
    --version)    shift; version;;
    *)            help "$@";;
  esac
}

main "$@"
