################################################################################
## questa.mk = Phony Make Rules for HDL Blocks in questasim                   ##
## This module does the following:                                            ##
## 1) Sets the following questasim make rules:                                ##
##    all, compile, sim, clean, recursiveclean                                ##
##                                                                            ##
## Manual Revision History                                                    ##
## 12/12/24 - JFW - Initial Release                                           ##
################################################################################
##
#############################################################
## HDL Buildfiles © 2025 by Jordan Woods is licensed under ##
## CC BY-NC-ND 4.0. To view a copy of this license, visit  ##
## https://creativecommons.org/licenses/by-nc-nd/4.0/      ##
#############################################################

include ../../make/common.mk

##########################
# USER OVERWRITABLE VARS #
##########################

HAS_TC ?= no

####################
# UNTOUCHABLE VARS #
####################

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
.PHONY: all
all: compile ;
else
.PHONY: all sim
all sim: compile
	@echo "Hello World from '$@' target!"
endif

.PHONY: clean
clean:
	$Vrm -rf work modelsim.ini sim

# TBD Make actually recursive
.PHONY: recursiveclean
recursiveclean: $(CLEAN_TARGETS) ;

.PHONY: compile
compile: comp_$(BLOCK) ;

########################
# BLOCK Pattern Rules ##
########################

# This will expand to `comp_lib_and`
# and is the phony target used for compiling a single block.
# Output products of compilation are:
# 1. the compiled library in ../lib_block/sim
.PHONY : comp_%
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(COMP_TARGETS) : comp_% : ../%/sim/_info ;

# Pattern for making the modelsim.ini
# May need a way to force this everytime, since an added
# pre-compiled library won't trigger the recipe.
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(INI_TARGETS) : ../%/modelsim.ini : $$($$*_DEPS)
	@cd ../$*
	$(foreach i, $($*_DEPENDENCY), $(call echo_command, vmap -quiet $i ../$i/sim))
	cd - > /dev/null

# Do the standard vlib / vmap / vcom for a questa library
# and put it a 'sim' folder in the module directory.
# Requires the modelsim.ini file with appropriate mappings in ../lib_block/modelsim.ini
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
.DELETE_ON_ERROR: ../%/sim/_info # Don't keep _info if it barfs
$(LIB_TARGETS) : ../%/sim/_info : ../%/modelsim.ini $$($$*_DEPS) $$($$*_COMPILE_ORDER)
	@set -e;
	if [ $(firstword $($*_COMPILE_ORDER)) ] ; then
		LOCAL_COMP="$($*_COMPILE_ORDER)"
	else
		LOCAL_COMP="$(wildcard ../$*/hdl/*)"
	fi
	$(eval libdir := $(dir $@))
	echo "~~ Starting Compiling $*  ~~"
	cd ../$* ;
	$(call echo_command, vlib -quiet $(libdir))
	$(call echo_command, vmap -quiet work $(libdir))
	if [[ $$(echo $$LOCAL_COMP | awk '{print $$1}') == @(*.vhdl|*.vho|*.vhd) ]]
	then
	$(call echo_command, vcom -work $(libdir) $($*_VCOM_OPT) $$LOCAL_COMP)
	else
	$(call echo_command, vlog -work $(libdir) $($*_VLOG_OPT) $$LOCAL_COMP)
	fi
	$(VECHO) "~~ Finishing Compiling $* ~~"
	cd - > /dev/null

# This will expand to `clean_lib_and`
# and is the phony target used for compiling a single block.
# Removed output products are:
# 1. the compiled library in ../lib_block/sim
.PHONY : $(CLEAN_TARGETS)
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(CLEAN_TARGETS) : clean_% : $$($$*_CLEAN_DEPS)
	@echo "~~ Cleaning $*  ~~"
	$(call echo_command, rm -rf ../$*/sim ../$*/modelsim.ini ../$*/work)

