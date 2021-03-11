#!/bin/bash

BASE_DIR=musl/
TARGET=x86_64-linux-musl

if [[ $1 == "windows" ]]; then
    TARGET=x86_64-w64-mingw32
fi

make MUSL_BASE_DIR=${BASE_DIR} MUSL_TARGET=${TARGET} 
