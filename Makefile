MUSL_BASE_DIR = # base path where you can find musl toolchains 'musl/'
MUSL_PATH = # path of the compiler, you don't need to set it
MUSL_TARGET = # 'x86_64-w64-mingw32', 'x86_64-linux-musl'.. check [https://musl.cc]
MUSL_CROSS = cross # 'cross' or 'native'

MUSL_BIN_DIR = 

PREFIX = 
CC := gcc
AR := ar

SRC_DIR = src/
INC_DIR = include/

BIN_DIR = bin/
LIB_DIR = lib/
OBJ_DIR = obj/

SRC = $(wildcard $(SRC_DIR)/*c)
OUT = cstar
INCLUDE = -I$(INC_DIR) -I$(SRC_DIR)

CFLAGS = -Wall -std=c99 -static -O2
LDFLAGS = 

-include config.mak

ifneq ($(MUSL_TARGET),)
    PREFIX ?= $(MUSL_TARGET)-
    MUSL_PATH ?= $(MUSL_BASE_DIR)$(PREFIX)$(MUSL_CROSS)
endif

ifneq ($(MUSL_PATH),)
    MUSL_BIN_DIR ?= $(MUSL_PATH)bin/
    MUSL_INCLUDE_FOLDER ?= $(MUSL_PATH)/$(MUSL_TARGET)include/
endif

LIBNAME ?= lib$(OUT)
DLIBNAME ?= $(LIBNAME).so
SLIBNAME ?= $(LIBNAME).a

ifdef MUSL_INCLUDE_FOLDER
    INCLUDE += -I$(MUSL_INCLUDE_FOLDER)
endif

ifeq ($(OS),Windows_NT)
    export Path := $(MUSL_BIN_DIR);$(Path)
else
    export PATH := $(MUSL_BIN_DIR):$(PATH)
endif

CROSS_CC = $(PREFIX)$(CC)
CROSS_AR = $(PREFIX)$(AR)

SOBJ = $(SRC:%.c=$(OBJ_DIR)/%.s.o)
DOBJ = $(SRC:%.c=$(OBJ_DIR)/%.d.o)

LDFLAGS += -L$(LIB_DIR) -l$(OUT)
FOLDERS = $(BIN_DIR) $(LIB_DIR) $(OBJ_DIR)

.PHONY: all
.SECONDARY: $(SOBJ) $(DOBJ)

all: setup $(LIB_DIR)/$(SLIBNAME) $(LIB_DIR)/$(DLIBNAME) $(BIN_DIR)/$(OUT).bin
	@echo $(MUSL_PATH)

$(FOLDERS):
	@mkdir -p $@

setup: $(FOLDERS)

%.bin:
	@echo "********************************************************"
	@echo "** COMPILING $@" 
	@echo "********************************************************\n"
	$(CROSS_CC) main.c -o $@ $(CFLAGS) $(INCLUDE) $(LDFLAGS) 
	@echo "\n"

%.a: $(SOBJ)
	@echo "********************************************************"
	@echo "** CREATING $@"
	@echo "********************************************************"
	$(CROSS_AR) rcs $@ $(SOBJ)
	@echo "\n"

%.so: $(DOBJ)
	@echo "********************************************************"
	@echo "** CREATING $@\r"
	@echo "********************************************************"
	$(CROSS_CC) -shared -o $@ $(DOBJ)
	@echo "\n"

$(OBJ_DIR)/%.s.o: %.c
	@echo "********************************************************"
	@echo "** $(SLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ $(CFLAGS) $(INCLUDE) $(LDFLAGS)

$(OBJ_DIR)/%.d.o: %.c
	@echo "********************************************************"
	@echo "** $(DLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ -fPIC $(CFLAGS) $(INCLUDE) $(LDFLAGS)

clean:
	rm -rf $(OUT)
	rm -rf $(DLIBNAME) $(SLIBNAME)
	rm -rf $(FOLDERS)
