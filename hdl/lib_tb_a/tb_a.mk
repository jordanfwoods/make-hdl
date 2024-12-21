include ../lib_and/and.mk

BLOCK := lib_tb_a
$(BLOCK)_DEPENDENCY := lib_and

include ../../make/questa_blocks.mk

