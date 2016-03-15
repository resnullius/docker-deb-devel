#!/usr/bin/env sh
set -e
USER=$(whoami)
ARCH=$(uname -m)
BUILD_ARCH="$ARCH"

PRE=$(echo "$ARCH" | grep "arm") && echo "ANYTHING"
if [ "$PRE" == "$ARCH" ]; then
  BUILD_ARCH="armhf"
fi

REPO_DIR=/opt/repo/"$BUILD_ARCH"

copy_keys() {
  mkdir "$HOME"/.abuild
  sudo cp /opt/keys/*.rsa* "$HOME"/.abuild/ && \
    sudo chown "$USER" "$HOME"/.abuild/*
  sudo cp /opt/keys/*.rsa.pub /etc/apk/keys
}

copy_src() {
  sudo cp -R /opt/src/* "$HOME"/src && \
    sudo chown -R "$USER" "$HOME"/src
}

add_local_repo() {
  [ -d "$REPO_DIR" ] && \
    [ -f "$REPO_DIR"/APKINDEX.tar.gz ] && \
    sudo sh -c "echo /opt/repo >> /etc/apk/repositories"
  echo "If there was anything on your repo, it's available now"
}

run_build() {
  mkdir -p "$HOME"/packages
  abuild-apk update
  abuild checksum && abuild "$@"
}

copy_finalpkg() {

  [ -d "$REPO_DIR" ] || sudo mkdir -p "$REPO_DIR"
  sudo cp "$HOME"/packages/builder/"$BUILD_ARCH"/*.apk /opt/repo/"$BUILD_ARCH"/
}

gen_apkindex() {
  cd /opt/repo/"$BUILD_ARCH"/
  sudo apk index -o APKINDEX.tar.gz ./*.apk
  sudo abuild-sign APKINDEX.tar.gz
}

update_apkbuild() {
  sudo cp "$HOME"/src/APKBUILD /opt/src/
}

main() {
  sh /bin/setup-system.sh

  copy_keys
  copy_src
  add_local_repo
  run_build "$@"
  copy_finalpkg
  gen_apkindex
  update_apkbuild
}

main "$@"
