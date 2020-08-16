#! /bin/bash

if [ ${EUID} -eq 0 ]; then
  echo "This script must not be executed as root!"
  exit 1
fi

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)
OPERATING_SYSTEM=${OSTYPE//[0-9.-]*/}

# Detect OS, as some parameters must be obtained differently.
case $OPERATING_SYSTEM in
  linux*)
    USER_UID=`stat -c "%u" .`
    USER_GID=`stat -c "%g" .`
    ;;
  darwin*)
    USER_UID=1000
    USER_GID=1000
    ;;
  *)
    echo "Unsupported OS, please contact the developers for help."
    exit
    ;;
esac

docker build -t nrf52_compile_env $PROJECT_ROOT/toolchain \
 --build-arg USER_USERNAME=`whoami` \
 --build-arg USER_UID=$USER_UID \
 --build-arg USER_GID=$USER_GID