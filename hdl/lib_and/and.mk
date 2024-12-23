include ../osvvm/osvvm.mk

BLOCK := lib_and
$(BLOCK)_DEPENDENCY := osvvm

include ../../make/questa/questa_blocks.mk

