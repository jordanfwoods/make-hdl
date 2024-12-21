include ../lib_osvvm/osvvm.mk

BLOCK := lib_and
$(BLOCK)_DEPENDENCY := lib_osvvm

include ../../make/questa_blocks.mk

