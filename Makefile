NAME = cstar
CSTD = c99
CFLAGS =
LFLAGS = 
MAIN = main.c

MODULES = 

PREFIX =
CC = gcc
AR = ar

MUSL_BIN =
MUSL_INC =
MUSL_DIR =
MUSL_TOOLCHAIN_DIR = 
MUSL_TARGET = 
MUSL_CROSS = 

LIBNAME = lib$(NAME)
SLIBNAME = $(LIBNAME).a
DLIBNAME = $(LIBNAME).so

BIN_DIR = bin
OBJ_DIR = obj
LIB_DIR = lib

SRC_DIR = src
INC_DIR = include

INCLUDE =

-include config.mak

SRC += $(wildcard $(SRC_DIR)/*.c)
INCLUDE += -I$(INC_DIR) -I$(SRC_DIR)

OBJ = $(SRC:%.c=$(OBJ_DIR)/%.o)
SOBJ = $(OBJ:%.o=%.s.o)
DOBJ = $(OBJ:%.o=%.d.o)

FOLDERS = $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR)

CFLAGS =-Wall -std=$(CSTD)

ifneq ($(MUSL_TARGET),)
    ifneq ($(MUSL_TOOLCHAIN_DIR),)
    MUSL_BIN = $(MUSL_TOOLCHAIN_DIR)/bin
    MUSL_INC = $(MUSL_TOOLCHAIN_DIR)/$(MUSL_TARGET)/include
    endif
endif

ifneq ($(MUSL_BIN),)
    ifeq ($(OS),Window_NT)
    export Path = $(MUSL_BIN);$(Path)
    else
    export PATH = $(MUSL_BIN):$(PATH)
    endif
endif

ifneq ($(MUSL_INC),)
    INCLUDE += -I$(MUSL_INC)
endif

CROSS_CC = $(PREFIX)$(CC)
CROSS_AR = $(PREFIX)$(AR)

SLIBOUT = $(SLIBNAME:%=$(LIB_DIR)/$(SLIBNAME))
DLIBOUT = $(DLIBNAME:%=$(LIB_DIR)/$(DLIBNAME))
OUT = $(NAME:%=$(BIN_DIR)/%)

build: folders $(OUT)

folders: $(FOLDERS)

all: folders $(SLIBOUT) $(DLIBOUT) $(OUT)

.PHONY: all build folders
.SECONDARY: $(SOBJ) $(DOBJ)


$(FOLDERS):
	@mkdir -p $@

$(OUT): $(MAIN) $(SLIBOUT)
	@echo "********************************************************"
	@echo "** COMPILING $@"
	@echo "********************************************************"
	$(CROSS_CC) $(MAIN) -o $@ $(INCLUDE) $(CFLAGS) -L$(LIB_DIR) -l$(NAME) $(MODULES:%=-l%) $(LFLAGS)
	@echo ""

%.a: $(SOBJ)
	@echo "********************************************************"
	@echo "** CREATING $@"
	@echo "********************************************************"
	$(CROSS_AR) rcs $@ $(SOBJ)
	@echo ""

%.so: $(DOBJ)
	@echo "********************************************************"
	@echo "** CREATING $@"
	@echo "********************************************************"
	$(CROSS_CC) -shared -o $@ $(DOBJ) $(INCLUDE) $(CFLAGS)
	@echo ""

$(OBJ_DIR)/%.s.o: %.c
	@echo "********************************************************"
	@echo "** $(SLIBNAME): COMPILING SOURCE $<"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ $(INCLUDE) $(CFLAGS) 

$(OBJ_DIR)/%.d.o: %.c
	@echo "********************************************************"
	@echo "** $(DLIBNAME): COMPILING SOURCE $<"
	@echo "********************************************************"
	@mkdir -p '$(@D)'
	$(CROSS_CC) -c $< -o $@ -fPIC $(INCLUDE) $(CFLAGS)

$(MODULES):
	make lib$@.a -C modules/$@
	cp modules/$@/lib$@.a lib/

clean_modules:
	make clean -C modules/$@

clean:
	rm -rf $(OUT)
	rm -rf $(DLIBNAME) $(SLIBNAME)
	rm -rf $(FOLDERS)

clean_all: clean clean_modules
