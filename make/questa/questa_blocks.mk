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
$(eval $(BLOCK)_COMPILE_ORDER ?= $(wildcard ../$(BLOCK)/hdl/*))
# names of libraries this block is dependent on.
$(eval $(BLOCK)_DEPENDENCY    ?=)
# If this is a testbench with testcases, allow for 'vsim'
$(eval $(BLOCK)_HAS_TC        ?= no)
# VHDL Compile options
$(eval $(BLOCK)_VCOM_OPTS     ?= -quiet -pedanticerrors -2008)
# Verilog Compile options
$(eval $(BLOCK)_VLOG_OPTS     ?= -quiet -pedanticerrors -sv)
# Questa Simulation options
$(eval $(BLOCK)_VSIM_OPTS     ?= -pedanticerrors)
# Testcase to be run
$(eval TC                     ?= tb)
# Testbench top-level for simulatable libraries
$(eval $(BLOCK)_TB_TOP        ?= $(TC))
# Library has a mix of VHDL and Verilog.
$(eval $(BLOCK)_MIXED_HDL     ?=)

####################
# UNTOUCHABLE VARS #
####################

### BLOCK Specific Generated Variables ###

# Actual output products of dependent libraries. This allows for the user to
# just give a block name.
# NOTE: currently looks at _info, but that could be changed in the future, TBD.
$(eval $(BLOCK)_DEPS          := $(patsubst %,../%/sim/_info,$($(BLOCK)_DEPENDENCY)))
# Dependent Items to clean. Enables Recursive Cleaning.
$(eval $(BLOCK)_CLEAN_DEPS    := $(patsubst %,clean_%,$($(BLOCK)_DEPENDENCY)))

### Concatenated lists for all BLOCKs (So MAKE can find our hypothetical targets easier) ###

# List of files for full clean
$(eval CLEAN_TARGETS          := $(CLEAN_TARGETS) clean_$(BLOCK))
# List of .PHONY comp_objects
$(eval COMP_TARGETS           := $(COMP_TARGETS) comp_$(BLOCK))
# List of modelsimi.ini's
$(eval INI_TARGETS            := $(INI_TARGETS) ../$(BLOCK)/modelsim.ini)
# List of questa libraries
$(eval LIB_TARGETS            := $(LIB_TARGETS) ../$(BLOCK)/sim/_info)
# VSIM Libraries
$(eval VSIM_LIB_OPTS          := $(VSIM_LIB_OPTS) -L $(BLOCK))
# MODELSIM.INI DEPENDENTS
$(eval $(BLOCK)_INI_DEPS := $($(BLOCK)_DEPENDENCY) $(foreach i, $($(BLOCK)_DEPENDENCY), $($i_DEPENDENCY)))

ifdef GUI
$(eval $(BLOCK)_GUI :=)
else
$(eval $(BLOCK)_GUI := -c)
endif

endif
