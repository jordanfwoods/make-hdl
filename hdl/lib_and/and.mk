########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################
include ../osvvm/osvvm.mk

BLOCK := lib_and
$(BLOCK)_DEPENDENCY := osvvm

include ../../make/questa/questa_blocks.mk

