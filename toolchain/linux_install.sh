#!/bin/bash

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)

if [ ${EUID} -ne 0 ]; then
  echo "This script must be executed as root!"
  exit 1
fi

apt update
apt install -y build-essential cmake unzip wget python python-pip

dpkg -i $PROJECT_ROOT/toolchain/files/nRF-Command-Line-Tools_10_7_0_Linux-amd64.deb

cd /tmp
rm -rf nrf52-dev-env
mkdir -p nrf52-dev-env
cd nrf52-dev-env

    rm -rf /opt/arm-none-eabi-gcc
    wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
    tar -xvf gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
    mv gcc-arm-none-eabi-8-2018-q4-major /opt/arm-none-eabi-gcc
    rm gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2

    pip install nrfutil

# Remove temp folder
cd ..
rm -rf nrf52-dev-env
