#!/usr/bin/env bash
# vim: ft=sh tw=80

declare help="
"

declare ARCH
ARCH=$(uname -m)
declare BUILD_ARCH="$ARCH"
declare OUTPUT_DIR="/opt/pkgs"
declare PKG_NAME

declare PRE
PRE=$(echo "$ARCH" | grep "arm")
if [ "$PRE" == "$ARCH" ]; then
  BUILD_ARCH="armhf"
fi

eval_opts() {
  while getopts ":o:p:" opt "$@"; do
    case "$opt" in
      o)    OUTPUT_DIR="$OPTARG";;
      p)    PKG_NAME="$OPTARG";;
      \?)   echo "Invalid option -$OPTARG was ignored." >&2;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        echo "$help"
        exit 1;;
    esac
  done
}

cp_to_workplace() {
  mkdir "$PKG_NAME"
  cp -r /opt/src/* "$PWD"/"$PKG_NAME"/
}

print_motd() {
  echo "Building pkg $PKG_NAME for arch $BUILD_ARCH"
  echo "Final package will be put on $OUTPUT_DIR"
}

install_builddeps() {
  mk-build-deps --install "$PKG_NAME"/debian/control
}

run_build() {
  pushd "$PKG_NAME"
  dpkg-buildpackage -us -uc
  popd
}

mv_pkgs() {
  mv "$PWD"/*.{deb,dsc,changes,tar.gz} "$OUTPUT_DIR"
}

main() {
  set -eo pipefail; [[ "$TRACE" ]] && set -x

  eval_opts "$@"
  cp_to_workplace
  [ -e "$KEEP_QUIET" ] && print_motd
  install_builddeps
  run_build
  mv_pkgs
}

main "$@"
