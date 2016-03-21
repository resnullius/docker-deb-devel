setup() {
  docker history resnullius/debian-devel:unstable >/dev/null 2>&1
}

@test "distro is correct" {
  run docker run --rm --entrypoint bash resnullius/debian-devel:unstable -c "cat /etc/os-release"
  [ $status -eq 0 ]
  [ "${lines[2]}" = "ID=debian" ]
}

@test "version is correct" {
  run docker run --rm --entrypoint bash resnullius/debian-devel:unstable -c "cat /etc/debian_version"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "stretch/sid" ]
}
