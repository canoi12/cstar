#!/bin/bash

PREFIX="x86_64-linux-musl-"
CROSS="cross"
MUSL_PATH="musl/${PREFIX}${CROSS}"

if [[ $1 == "windows" ]]; then
    PREFIX="x86_64-w64-mingw32-"
fi

MUSL_PATH="musl/${PREFIX}${CROSS}"

make MUSL_PATH=$MUSL_PATH PREFIX=$PREFIX
