################################################################################
## questa.mk = Phony Make Rules for HDL Blocks in questasim                   ##
## This module does the following:                                            ##
## 1) Sets the following questasim make rules:                                ##
##    all, compile, sim, clean, recursiveclean, regression, comp_<lib>, etc.  ##
##                                                                            ##
## Manual Revision History                                                    ##
## 12/12/24 - JFW - Initial Release                                           ##
################################################################################
##
########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################

include ../../make-hdl/common.mk

##########################
# USER OVERWRITABLE VARS #
##########################

HAS_TC ?= no

####################################
# PRE-DEFINED ROUTINES / FUNCTIONS #
####################################

## Function: questa_compile
# Generic function that calls 'vcom' if VHDL file is provided, else 'vlog'
# Parameters:
# 1 : HDL File path (or list of HDL Files)
# 2 : Library target (i.e. ../lib_and/sim/_info, etc)
define questa_compile
	if [[ "$(1)" != "" ]]; then
		if [[ $(firstword $(1)) == @(*.vhdl|*.vho|*.vhd) ]]; then
			$(call echo_command, vcom -work $(dir $(2)) $($*_VCOM_OPTS) $(1))
		else
			$(call echo_command, vlog -work $(dir $(2)) $($*_VLOG_OPTS) $(1))
		fi
	fi
endef

## Function: questa_mixed_compile
# Highly Specific function that looks at the compile order, and compiles all consecutive
# VHDL / Verilog Files in one command.
# It takes no parameters, but assumes that $($(BLOCK)_COMPILE_ORDER) is not empty, and
# is in a generic recipe (i.e. $@ and $* are non-zero)
define questa_mixed_compile
	IS_VHDL=false
	if [[ $(firstword $($*_COMPILE_ORDER)) == @(*.vhdl|*.vho|*.vhd) ]] ; then IS_VHDL=true; fi
	for i in $($*_COMPILE_ORDER); do
		if $$IS_VHDL && [[ $$i == @(*.vhdl|*.vho|*.vhd) ]] ; then
			CURR_COMPILE+=" $$i"
		elif $$IS_VHDL ; then
			$(call questa_compile, $$CURR_COMPILE, $@, $*)
			CURR_COMPILE="$$i"
			IS_VHDL=false
		elif [[ $$i == @(*.vhdl|*.vho|*.vhd) ]] ; then
			$(call questa_compile, $$CURR_COMPILE, $@, $*)
			CURR_COMPILE="$$i"
			IS_VHDL=true
		else
			CURR_COMPILE+=" $$i"
		fi
	done
	$(call questa_compile, $$CURR_COMPILE, $@, $*)
endef

## Define the VSIM command to be called by 'all/sim/simulate' AND 'regression' targets
define questa_vsim
mkdir -p results
vsim work.$(1) -l results/$(1).log -L work $(VSIM_LIB_OPTS) $($(BLOCK)_VSIM_OPTS) $($(BLOCK)_GUI) -do 'run -all; quit -code [coverage attribute -name TESTSTATUS -concise]'
endef

######################
## GNU MAKE Options ##
######################

# Don't delete intermediate files like modelsim.ini
.NOTINTERMEDIATE:
# all lines of recipe happen in one shell instance to make writing the recipes easier.
.ONESHELL:

##################
# GLOBAL TARGETS #
##################

ifeq ($(HAS_TC),no)
# Define the all target to be 'compile' if there are no testcases,
.PHONY: all
all: compile
	@$(call end_time)

else
# otherwise define a 'sim' target and use that for 'all'.
.PHONY: all sim simulate
all sim simulate: compile
	@set -e
	echo "~~ Starting Simulating $(BLOCK).$($(BLOCK)_TB_TOP) ~~"
	$(call questa_vsim,$($(BLOCK)_TB_TOP))
	$(call end_time)

# regression just compiles the results of the regression.
.PHONY: regression
regression: run_regression_list
	@$(call setup_regression)
	$(call compile_regression,$(BLOCK),results,$($(BLOCK)_REGRESSION_LIST))
	$(call finish_regression,$(BLOCK),$($(BLOCK)_REGRESSION_LIST))

$(BLOCK)_REGRESSION_LIST ?=
# run_regression_list loops through each tc in the regression list, and runs them.
.PHONY: run_regression_list
run_regression_list: compile
ifeq (,$($(BLOCK)_REGRESSION_LIST))
	$(error REGRESSION LIST IS EMPTY!)
else
	@for i in $($(BLOCK)_REGRESSION_LIST); do
		echo "~~ Starting Simulating $(BLOCK).$$i ~~"
		$(call questa_vsim,$$i)
	done
	$(call end_time)
	: # Ensure this recipe doesn't end on an error
endif

endif

# Basic clean target for current directory
.PHONY: clean
clean:
	$Vrm -rf work modelsim.ini sim
	$(call end_time)

# Recursively look through dependency libraries and clean those libraries
.PHONY: recursiveclean
recursiveclean: $(CLEAN_TARGETS)
	@$(call end_time)

# For the generic 'compile' target, just call the specific comp_ target for our block.
.PHONY: compile
compile: comp_$(BLOCK)
	@$(call end_time)

########################
# BLOCK Pattern Rules ##
########################

# This will expand to `comp_lib_and`
# and is the phony target used for compiling a single block.
# This just hides the messy questa compiled library files.
.PHONY : comp_%
$(COMP_TARGETS) : comp_% : ../%/sim/_info
	@$(call end_time)

# Pattern for making the modelsim.ini
# TODO May need a way to force this everytime, since an added
# pre-compiled library won't trigger the recipe.
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(INI_TARGETS) : ../%/modelsim.ini : $$($$*_DEPS)
	@set -e
	cd ../$*
	for i in $($*_INI_DEPS); do
		$(call echo_command, vmap -quiet $$i ../$$i/sim)
	done
	cd - > /dev/null
	$(call end_time)

# Do the standard vlib / vmap / vcom for a questa library
# and put it a 'sim' folder in the target block's directory.
# Requires the modelsim.ini file with appropriate mappings in ../lib_<block>/modelsim.ini
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
.DELETE_ON_ERROR: ../%/sim/_info # Don't keep _info if it barfs
$(LIB_TARGETS) : ../%/sim/_info : ../%/modelsim.ini $$($$*_DEPS) $$($$*_COMPILE_ORDER)
	@set -e
	echo "~~ Starting Compiling $*  ~~"
	cd ../$*
	$(call echo_command, vlib -quiet $(dir $@))
	$(call echo_command, vmap -quiet work $(dir $@))
	if [[ "$($*_MIXED_HDL)" == "" ]]; then
		$(call questa_compile, $($*_COMPILE_ORDER), $@, $*)
	else
		$(call questa_mixed_compile)
	fi
	$(VECHO) "~~ Finishing Compiling $* ~~"
	cd - > /dev/null
	$(call end_time)

# This will expand to `clean_lib_and`
# and is the phony target used for compiling a single block.
# Removed output products are:
# 1. the compiled library in ../lib_<block>/{sim,modelsim.ini,work}
.PHONY : $(CLEAN_TARGETS)
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(CLEAN_TARGETS) : clean_% : $$($$*_CLEAN_DEPS)
	@echo "~~ Cleaning $*  ~~"
	$(call echo_command, rm -rf ../$*/sim ../$*/modelsim.ini ../$*/work)
	$(call end_time)
