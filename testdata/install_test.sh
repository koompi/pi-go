#!/bin/bash

function error() {
  echo "ERROR: $1"
  exit 1
}

echo "Start simple"
./pi -S shfmt --noconfirm || error "unable to make shfmt"

./pi -Qsq shfmt || error "unable to install shfmt"

exit 0
