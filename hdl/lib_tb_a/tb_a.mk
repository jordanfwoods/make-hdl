########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################
include ../lib_and/and.mk

BLOCK := lib_tb_a
$(BLOCK)_DEPENDENCY := lib_and

include ../../make/questa/questa_blocks.mk

