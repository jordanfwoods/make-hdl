########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################
include ../lib_dependent_lib1/dependent_lib1.mk
include ../lib_dependent_lib2/dependent_lib2.mk

BLOCK := library

$(BLOCK)_DEPENDENCY := lib_dependent_lib1 lib_dependent_lib2

$(BLOCK)_COMPILE_ORDER := ../$(BLOCK)/hdl/file1.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/file2.sv
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/file3.svh
# $(BLOCK)_COMPILE_ORDER += ...
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/filen.vhdl

$(BLOCK)_MIXED_HDL := yes

include ../../make/questa/questa_blocks.mk

