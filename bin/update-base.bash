#!/usr/bin/env bash

declare help="
Update script for base into versions.

Usage:
  update-base.bash run
  update-base.bash --version
  update-base.bash -h | --help

Options:
  -h --help                 Show this screen.
  --version                 Show versions.
"

declare version="
Version: 1.0.0.
Licensed under the MIT terms.
"

declare BASE_DIR="${BASE_DIR:-$PWD/base/}"
declare FILES_BASE="${FILES_BASE:-Dockerfile.base}"
declare FILES_CHILDS="${FILES_CHILDS:-unstable}"
declare FILES_CHILDS_DIR="${FILES_CHILDS_DIR:-versions/base}"

copy_files() {
  for file in $FILES_CHILDS; do
    echo "Copying and renaming for $file"
    mkdir -p "$FILES_CHILDS_DIR"/"$file"
    cp "$BASE_DIR"/"$FILES_BASE" "$FILES_CHILDS_DIR"/"$file"/Dockerfile
    rm -rf "$FILES_CHILDS_DIR"/"$file"/scripts
    cp -R "$BASE_DIR"/scripts "$FILES_CHILDS_DIR"/"$file"/
    cp "$BASE_DIR"/options "$FILES_CHILDS_DIR"/"$file"/options
  done
}

change_version() {
  for file in $FILES_CHILDS; do
    echo "Changing tag for $file"
    sed -i '' -e "s/debian:/debian:$file/" "$FILES_CHILDS_DIR/$file/Dockerfile"
    sed -i '' -e "s/debian-devel:/debian-devel:$file/" \
      "$FILES_CHILDS_DIR/$file/options"
  done
}

run_updater() {
  copy_files
  change_version
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
    run)              shift; run_updater "$@";;
    -h|--help)        shift; help "$@";;
    --version)        shift; version;;
    *)                help "$@";;
  esac
}

main "$@"
