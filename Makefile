# Makefile for A09

all: a09

clean:
	-$(RM) a09

INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
prefix := /usr/local
exec_prefix := $(prefix)
bindir := $(exec_prefix)/bin

install: a09
	$(INSTALL_PROGRAM) a09 $(bindir)/a09
