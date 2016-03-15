@test "architecture is correct" {
  run uname -m
  [ $status -eq 0 ]
  [ "$output" = "x86_64" ]
}
