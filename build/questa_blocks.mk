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

##########################
# USER OVERWRITABLE VARS #
##########################

# if unspecified, just grab everything in the hdl folder.
$(BLOCK)_COMPILE_ORDER ?= $(wildcard ../$(BLOCK)/hdl/*)
# names of libraries this block is dependent on.
$(BLOCK)_DEPENDENCY    ?=
# If this is a testbench with testcases, allow for 'vsim'
$(BLOCK)_HAS_TC        ?= no
# VHDL Compile options
$(BLOCK)_VCOM_OPT      ?= -quiet -2008
# Verilog Compile options
$(BLOCK)_VLOG_OPT      ?= -quiet -sv
# toggle verbosity
VERBOSE                ?=

####################
# UNTOUCHABLE VARS #
####################

# Actual output products of dependent libraries. This allows for the user to
# just give a block name.
# NOTE: currently looks at _info, but that could be changed in the future, TBD.
$(BLOCK)_DEPS          := $(patsubst %,../%/sim/_info,$($(BLOCK)_DEPENDENCY))

# Fancy way of toggling verbosity.
ifeq ($(VERBOSE),)
V := @
else
V :=
endif

######################
## GNU MAKE Options ##
######################

# Don't delete intermediate files like modelsim.ini
.NOTINTERMEDIATE:
# Make writing the recipes easier.
.ONESHELL:
# Allow for funny business like double $ in the dependency list
.SECONDEXPANSION :
# Don't keep _info if it barfs
.DELETE_ON_ERROR: ../%/sim/_info

########################
# BLOCK Pattern Rules ##
########################

# This will expand to `comp_lib_and`
# and is the phony target used for compiling a single block.
# Output products of compilation are:
# 1. the compiled library in ../lib_block/sim and
# 2. the modelsim.ini file with appropriate mappings in ../lib_block/modelsim.ini
.PHONY : comp_%
comp_% : ../%/modelsim.ini ../%/sim/_info ;

# Pattern for making the modelsim.ini
# May need a way to force this everytime, since an added
# pre-compiled library won't trigger the recipe.
../%/modelsim.ini : $$($$*_DEPS)
	$V$(foreach i, $($*_DEPENDENCY), $Vvmap -quiet $i ../$i/sim)

# Do the standard vlib / vmap / vcom for a questa library
# and put it a 'sim' folder in the module directory.
../%/sim/_info : $$($$*_DEPS) $$($$*_COMPILE_ORDER)
	@$(eval libdir := $(dir $@))
	@echo "~~ Starting Compiling $*  ~~"
	@cd ../$* ;
	$Vvlib -quiet $(libdir)
	$Vvmap -quiet work $(libdir)
	@if [[ $(suffix $(firstword $($*_COMPILE_ORDER))) == @(*.vhdl|*.vho|*.vhd) ]]
	then
	$Vvcom -work $(libdir) $($*_VCOM_OPT) $($*_COMPILE_ORDER)
	else
	vlog -work $(libdir) $($*_VLOG_OPT) $($*_COMPILE_ORDER)
	fi
	@echo "~~ Finishing Compiling $* ~~"
	@cd - > /dev/null

