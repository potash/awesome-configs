# Makefile for lsqlite3 library for Lua

# Compiler to use
CC = gcc
# Compiler flags
CFLAGS = -Ofast -pipe -fPIC
# Directories containing header files
INCLUDES = -I/usr/include
# define library paths
LFLAGS = -L/usr/lib
# libraries
LIBS = -lsqlite3
# build target
TARGET = lsqlite3

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(TARGET).o -c $(TARGET).c
	$(CC) -shared -o $(TARGET).so $(LFLAGS) $(TARGET).o $(LIBS)

clean:
	$(RM) $(TARGET).*o
