# cstar
C Start

a simple C base project to start with

compatible with [musl](https://musl.cc)

don't change variables in Makefile, create a `config.mak`

## project structure

by default, cstar search for these folders:

`include/` for headers
`src/` for sources

and the Makefile create these folders:
`bin/` to put binaries
`obj/` to put objects
`lib/` to put static and dynamic libraries

### setup musl

create a `musl/` folder, download the compilers at [https://musl.cc] and extract

set a `MUSL_TARGET` to the musl target arch: `x86_64-w64-mingw32`, `x86_64-linux-musl`

and `MUSL_CROSS` to `cross` or `native`. by default is `cross`

eg: 
- `make MUSL_TARGET=x86_64-linux-musl MUSL_CROSS=native`
- `make MUSL_TARGET=mips-linux-musl`
- `make MUSL_BASE_DIR=compilers/ MUSL_TARGET=mips-linux-musl`

other variables:

- `MUSL_BASE_DIR`, the directory that contains musl compilers. eg: `musl/`
- `MUSL_PATH`, the compiler's path. eg: `x86_64-w64-mingw-cross`, `x86_64-linux-musl-native`
- `MUSL_TARGET`, musl target platform. eg: `mips-linux-musl`, `i686-linux-musl`, `x86_64-linux-musl`
- `MUSL_CROSS`, used to complement with `MUSL_TARGET` and set correct compiler's folder. eg: `cross`, `native`
- `MUSL_BIN_FOLDER`, folder containing the musl binaries. eg: `musl/mips-linux-musl-cross/bin/`, `musl/x86_64-linux-musl-native`
- `MUSL_INCLUDE_FOLDER`, folder containing musl header. eg: `musl/x86_64-linux-musl-cross/x86_64-linux-musl/include`

- `PREFIX`, musl target prefix (autoset when you define `MUSL_TARGET`). eg: `x86_64-linux-musl-`
