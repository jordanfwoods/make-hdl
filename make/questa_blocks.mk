################################################################################
## questa_blocks.mk = Make Rules for HDL Blocks in questasim                  ##
## This module does the following:                                            ##
## 1) Sets the pattern rules for questasim compilation of any arbitrary       ##
##    HDL Library.                                                            ##
## NOTE: At the moment, any library must be all VHDL or Verilog.              ##
##                                                                            ##
## Manual Revision History                                                    ##
## 12/11/24 - JFW - Initial Release                                           ##
################################################################################
##
#############################################################
## HDL Buildfiles © 2025 by Jordan Woods is licensed under ##
## CC BY-NC-ND 4.0. To view a copy of this license, visit  ##
## https://creativecommons.org/licenses/by-nc-nd/4.0/      ##
#############################################################

# If we have already added it to the COMPILE Targets, then no need to run this again.
ifeq (,$(findstring comp_$(BLOCK), $(COMP_TARGETS)))

include ../../make/common.mk

##########################
# USER OVERWRITABLE VARS #
##########################

# if unspecified, just grab everything in the hdl folder.
$(BLOCK)_COMPILE_ORDER ?=
# names of libraries this block is dependent on.
$(BLOCK)_DEPENDENCY    ?=
# If this is a testbench with testcases, allow for 'vsim'
$(BLOCK)_HAS_TC        ?= no
# VHDL Compile options
$(BLOCK)_VCOM_OPT      ?= -quiet -2008
# Verilog Compile options
$(BLOCK)_VLOG_OPT      ?= -quiet -sv

####################
# UNTOUCHABLE VARS #
####################

### BLOCK Specific Generated Variables ###

# Actual output products of dependent libraries. This allows for the user to
# just give a block name.
# NOTE: currently looks at _info, but that could be changed in the future, TBD.
$(BLOCK)_DEPS          := $(patsubst %,../%/sim/_info,$($(BLOCK)_DEPENDENCY))
# Dependent Items to clean. Enables Recursive Cleaning.
$(BLOCK)_CLEAN_DEPS    := $(patsubst %,clean_%,$($(BLOCK)_DEPENDENCY))

### Concatenated lists for all BLOCKs (So MAKE can find our hypothetical targets easier) ###

# List of files for full clean
CLEAN_TARGETS          := $(CLEAN_TARGETS) clean_$(BLOCK)
# List of .PHONY comp_objects
COMP_TARGETS           := $(COMP_TARGETS) comp_$(BLOCK)
# List of modelsimi.ini's
INI_TARGETS            := $(INI_TARGETS) ../$(BLOCK)/modelsim.ini
# List of questa libraries
LIB_TARGETS            := $(LIB_TARGETS) ../$(BLOCK)/sim/_info

endif
