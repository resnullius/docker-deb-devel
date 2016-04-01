#!/usr/bin/env bash
# vim: ft=sh tw=80

declare help="
Usage:
  entrypoint.sh -p random [-o /opt/pkgs]

Options:
  -o    Output dir (change this if you changed the Dockerfile default from
        /opt/pkgs).
  -p    Package name (required)
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
  mkdir -p "$PKG_NAME"
  cp -r /opt/src/* "$PWD"/"$PKG_NAME"/
}

print_motd() {
  echo "Building pkg $PKG_NAME for arch $BUILD_ARCH"
  echo "Final package will be put on $OUTPUT_DIR"
}

download_upstream() {
  pushd "$PKG_NAME"
  uscan --force-download
  popd
}

install_builddeps() {
  pushd "$PKG_NAME"
  mk-build-deps --install --tool "/usr/bin/apt-get --no-install-recommends -y" ./debian/control
  popd
}

run_build() {
  pushd "$PKG_NAME"
  dpkg-buildpackage -us -uc
  popd
}

mv_pkgs() {
  mv "$PWD"/*.{deb,dsc,changes,tar.gz} "$OUTPUT_DIR"
}

print_help() {
  echo "$help"
}

main() {
  set -eo pipefail; [[ "$TRACE" ]] && set -x

  declare cmd="$1"
  case "$cmd" in
    -h|--help)
      print_help;;
    *)
      eval_opts "$@"
      cp_to_workplace
      [ -e "$KEEP_QUIET" ] && print_motd
      download_upstream
      install_builddeps
      run_build
      mv_pkgs;;
  esac
}

main "$@"
