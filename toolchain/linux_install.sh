#!/bin/bash

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)

if [ ${EUID} -ne 0 ]; then
  echo "This script must be executed as root!"
  exit 1
fi

apt update
apt install -y build-essential cmake unzip wget python python-pip

cd /tmp
rm -rf mk64f-dev-env
mkdir -p mk64f-dev-env
cd mk64f-dev-env

    rm -rf /opt/arm-none-eabi-gcc
    wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
    tar -xvf gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
    mv gcc-arm-none-eabi-8-2018-q4-major /opt/arm-none-eabi-gcc
    rm gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2

# Remove temp folder
cd ..
rm -rf mk64f-dev-env
