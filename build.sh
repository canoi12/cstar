#!/bin/bash

MUSL_TOOLCHAIN=x86_64-linux-musl
MUSL_CROSS=cross

if [[ $1 == "windows" ]]; then
    MUSL_TOOLCHAIN=x86_64-w64-mingw32
fi

echo "${MUSL_TOOLCHAIN}-${MUSL_CROSS}"

make MUSL_TOOLCHAIN=${MUSL_TOOLCHAIN} 
