#! /bin/bash

if [ ${EUID} -eq 0 ]; then
  echo "This script must not be executed as root!"
  exit 1
fi

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)

docker run -it --rm --name nrf52_compile_env -v ${PROJECT_ROOT}:/external nrf52_compile_env
