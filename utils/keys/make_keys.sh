#!/bin/bash

PROJECT_ROOT=$(realpath $(dirname `realpath $0`)/../..)

nrfutil keys generate $PROJECT_ROOT/vault/sample.pem
nrfutil keys display --key pk --format code $PROJECT_ROOT/vault/sample.pem --out_file $PROJECT_ROOT/vault/sample_public.c 