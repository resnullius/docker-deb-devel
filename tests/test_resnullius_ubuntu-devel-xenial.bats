setup() {
  docker history resnullius/ubuntu-devel:xenial >/dev/null 2>&1
}

@test "distro and version is correct" {
  run docker run --rm --entrypoint bash resnullius/ubuntu-devel:xenial -c "cat /etc/os-release"
  [ $status -eq 0 ]
  [ "${lines[2]}" = "ID=ubuntu" ]
  [ "${lines[9]}" = "UBUNTU_CODENAME=xenial" ]
}
