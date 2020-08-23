#!/bin/bash

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)
FW_TARGET=""
FLAG_DEBUG="-DCMAKE_BUILD_TYPE=release"
ARMGCC_DIR="/opt/arm-none-eabi-gcc"
TOOLCHAIN_FILE=${PROJECT_ROOT}"/sdk_cmake/armgcc.cmake"

# Parse the received commands
while :; do
    case $1 in
        -c|--clean) FLAG_CLEAN="SET"            
        ;;
        -d|--debug) FLAG_DEBUG="-DCMAKE_BUILD_TYPE=debug"            
        ;;
        --fw)
        FW_TARGET="$2"
        shift # past argument
        ;;
        *) break
    esac
    shift
done

# Cleanup the existing files
if [[ ! -z "$FLAG_CLEAN" ]]; then
    rm -rf $PROJECT_ROOT/bin/$FW_TARGET $PROJECT_ROOT/build/$FW_TARGET
fi

# Cleanup parsing of FW_TARGET
if [[ -z "$FW_TARGET" ]]; then
   echo "[ERROR] No target specified, aborting."
   exit -1
fi

# Compile!
mkdir -p $PROJECT_ROOT/build/$FW_TARGET
cd $PROJECT_ROOT/build/$FW_TARGET
cmake -B . -H$PROJECT_ROOT -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DTOOLCHAIN_DIR=$ARMGCC_DIR -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE -DFIRMWARE_TARGET=$FW_TARGET $FLAG_DEBUG
make -j8
cd $PROJECT_ROOT