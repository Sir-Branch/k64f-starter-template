#! /bin/bash

if [ ${EUID} -eq 0 ]; then
  echo "This script must not be executed as root!"
  exit 1
fi

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/..)

# Parse the received commands
while :; do
    case $1 in
        -c|--clean) FLAG_CLEAN="-c"          
        ;;
        -d|--debug) FLAG_DEBUG="-d"          
        ;;
        --fw)
        FLAG_FW_TARGET="--fw $2"
        shift # past argument
        ;;
        *) break
    esac
    shift
done

docker run -it --rm --name nrf52_compile_env -v ${PROJECT_ROOT}:/external nrf52_compile_env /external/toolchain/linux_compile.sh $FLAG_CLEAN $FLAG_FW_TARGET
