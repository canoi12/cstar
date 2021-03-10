MUSL_BASE_PATH ?= musl
ifdef MUSL_PATH
    MUSL_BIN_FOLDER = $(MUSL_PATH)/bin/
    MUSL_INCLUDE_FOLDER = $(MUSL_PATH)/x86_64-w64-mingw32/include/
endif

MUSL_BIN_FOLDER ?= 
MUSL_TOOLCHAIN ?= 

PREFIX := 
CC := gcc
AR := ar

BIN_FOLDER = bin
LIB_FOLDER = lib
OBJ_FOLDER = obj

SRC = $(wildcard src/*c) teste.c
OUT = cross
INCLUDE = -Iinclude -Isrc

LIBNAME = lib$(OUT)
DLIBNAME = $(LIBNAME).so
SLIBNAME = $(LIBNAME).a

CFLAGS = -Wall -std=c99 -static -O2
LDFLAGS = 

-include config.mak

ifdef MUSL_INCLUDE_FOLDER
    INCLUDE += -I$(MUSL_INCLUDE_FOLDER)
    #C_INCLUDE_PATH = $(MUSL_INCLUDE_FOLDER)
    #export CPATH :=  
endif

ifeq ($(OS),Windows_NT)
    export Path := $(MUSL_BIN_FOLDER);$(Path)
else
    export PATH := $(MUSL_BIN_FOLDER):$(PATH)
endif

CROSS_CC = $(PREFIX)$(CC)
CROSS_AR = $(PREFIX)$(AR)

SOBJ = $(SRC:%.c=$(OBJ_FOLDER)/%.s.o)
DOBJ = $(SRC:%.c=$(OBJ_FOLDER)/%.d.o)

LDFLAGS += -L$(LIB_FOLDER) -l$(OUT)
FOLDERS = $(BIN_FOLDER) $(LIB_FOLDER) $(OBJ_FOLDER)

.PHONY: all
.SECONDARY: $(SOBJ) $(DOBJ)

all: setup $(LIB_FOLDER)/$(SLIBNAME) $(LIB_FOLDER)/$(DLIBNAME) $(BIN_FOLDER)/$(OUT).bin

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

$(OBJ_FOLDER)/%.s.o: %.c
	@echo "********************************************************"
	@echo "** $(SLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ $(CFLAGS) $(INCLUDE) $(LDFLAGS)

$(OBJ_FOLDER)/%.d.o: %.c
	@echo "********************************************************"
	@echo "** $(DLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ -fPIC $(CFLAGS) $(INCLUDE) $(LDFLAGS)

clean:
	rm -rf $(OUT)
	rm -rf $(DLIBNAME) $(SLIBNAME)
	rm -rf $(FOLDERS)
