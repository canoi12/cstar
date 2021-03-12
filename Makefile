
MUSL_BASE_DIR =
MUSL_PATH =
MUSL_TARGET =
MUSL_CROSS = cross

MUSL_BIN_DIR = 

PREFIX = 
CC = gcc
AR = ar

SRC_DIR = src/
INC_DIR = include/

BIN_DIR = bin/
LIB_DIR = lib/
OBJ_DIR = obj/

SRC =
OUT ?= cstar

CFLAGS = -Wall -std=c99 -static -O2
LDFLAGS = 

-include config.mak

INCLUDE += -I$(INC_DIR) -I$(SRC_DIR)

ifneq ($(MUSL_TARGET),)
    PREFIX = $(if $(MUSL_TARGET),$(MUSL_TARGET)-,)
    MUSL_PATH = $(MUSL_BASE_DIR)/$(PREFIX)$(MUSL_CROSS)
endif

ifneq ($(MUSL_PATH),)
    MUSL_BIN_DIR = $(MUSL_PATH)/bin/
    MUSL_INCLUDE_FOLDER = $(MUSL_PATH)/$(MUSL_TARGET)/include/
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

S_DIR = $(realpath $(SRC_DIR))
ifeq ($(SRC),)
    SRC := $(wildcard $(S_DIR)/*.c)  
endif

O_DIR = $(realpath $(OBJ_DIR))
L_DIR = $(realpath $(LIB_DIR))
B_DIR = $(realpath $(BIN_DIR))

OBJ = $(SRC:%.c=$(O_DIR)/%.o)

SOBJ = $(OBJ:%.o=%.s.o)
DOBJ = $(OBJ:%.o=%.d.o)

LDFLAGS += -L$(LIB_DIR) -l$(OUT)
FOLDERS = $(BIN_DIR) $(LIB_DIR) $(OBJ_DIR)


.PHONY: all
.SECONDARY: $(SOBJ) $(DOBJ)

all: setup $(L_DIR)/$(SLIBNAME) $(L_DIR)/$(DLIBNAME) $(B_DIR)/$(OUT).bin

$(FOLDERS):
	@mkdir -p $@

setup: $(FOLDERS)

cstar: cstar.c
	gcc $< -o cstar

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

$(O_DIR)/%.s.o: %.c
	@echo "********************************************************"
	@echo "** $(SLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ $(CFLAGS) $(INCLUDE) $(LDFLAGS)

$(O_DIR)/%.d.o: %.c
	@echo "********************************************************"
	@echo "** $(DLIBNAME): COMPILING SOURCE $<\r"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ -fPIC $(CFLAGS) $(INCLUDE) $(LDFLAGS)

clean:
	rm -rf $(OUT)
	rm -rf $(DLIBNAME) $(SLIBNAME)
	rm -rf $(FOLDERS)
