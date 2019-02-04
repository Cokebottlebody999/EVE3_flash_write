#
# Copyright (c) Riverdi Sp. z o.o. sp. k. <riverdi@riverdi.com>
# Copyright (c) Skalski Embedded Technologies <contact@lukasz-skalski.com>
#

# Project name
PROJECT = eve3-flash-write

# List all C defines here

DEFS = -DFT232H_MINGW_PLATFORM
DEFS += -DBUFFER_OPTIMIZATION

DEFS += -DEVE_3
DEFS += -DCTP_43

# Define optimisation level here
OPT =

# Tools
PREFIX =
CC   = $(PREFIX)gcc
CXX  = $(PREFIX)g++
GDB  = $(PREFIX)gdb
CP   = $(PREFIX)objcopy
AS   = $(PREFIX)gcc -x assembler-with-cpp

# List of source files
SRC  = ./$(PROJECT).c
SRC += ./eve3-flash-utils.c

SRC += ./host_layer/ft232h_mingw/platform.c

SRC += ./eve_layer/Gpu_Hal.c
SRC += ./eve_layer/CoPro_Cmds.c
SRC += ./eve_layer/Hal_Utils.c
SRC += ./app_layer/App_Common.c

# List all include directories here
INCDIRS  = ./
INCDIRS += ./host_layer/ft232h_mingw
INCDIRS += ./host_layer/ft232h_mingw/lib
INCDIRS += ./eve_layer
INCDIRS += ./app_layer
INCDIRS += ./riverdi_modules

# List the user directory to look for the libraries here
LIBDIRS += ./host_layer/ft232h_mingw/lib

# List all user libraries here
LIBS = MPSSE

# Dirs
OBJS    = $(SRC:.c=.o)
INCDIR  = $(patsubst %,-I%, $(INCDIRS))
LIBDIR  = $(patsubst %,-L%, $(LIBDIRS))
LIB     = $(patsubst %,-l%, $(LIBS))

# Flags
COMMONFLAGS =
ASFLAGS = $(COMMONFLAGS)
CPFLAGS = $(COMMONFLAGS) $(DEFS)
LDFLAGS = $(COMMONFLAGS) $(LIBDIR) $(LIB)

#
# Makefile Rules
#

all: $(PROJECT)

$(PROJECT): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

%.o: %.c
	$(CC) -c $(CPFLAGS) -I . $(INCDIR) $< -o $@

%.o: %.s
	$(AS) -c $(ASFLAGS) $< -o $@

clean:
	-rm -rf $(PROJECT)
	-rm -rf $(OBJS)
	-rm -rf $(SRC:.c=.lst)
	-rm -rf $(ASRC:.s=.lst)
