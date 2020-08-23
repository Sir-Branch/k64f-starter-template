#!/bin/sh
PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)
TOOLCHAIN_FILE="../../sdk_cmake/armgcc.cmake"
ARMGCC_DIR="/opt/arm-none-eabi-gcc"

cmake -S$PROJECT_ROOT -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE -DTOOLCHAIN_DIR=$ARMGCC_DIR -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=release  .
make -j4
