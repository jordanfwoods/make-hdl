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

####################################
# PRE-DEFINED ROUTINES / FUNCTIONS #
####################################

define questa_compile
	if [[ "$(1)" != "" ]]; then
		if [[ $(firstword $(1)) == @(*.vhdl|*.vho|*.vhd) ]]; then
			$(call echo_command, vcom -work $(dir $(2)) $($*_VCOM_OPT) $(1))
		else
			$(call echo_command, vlog -work $(dir $(2)) $($*_VLOG_OPT) $(1))
		fi
	fi
endef

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
	@set -e
	echo "~~ Starting Simulating $(BLOCK).$($(BLOCK)_TB_TOP) ~~"
	$(call echo_command, vsim work.$($(BLOCK)_TB_TOP) $(VSIM_LIB_OPTS) $($(BLOCK)_GUI) -do 'run -all')
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
	@set -e
	cd ../$*
	for i in $($*_INI_DEPS); do
		$(call echo_command, vmap -quiet $$i ../$$i/sim)
	done
	cd - > /dev/null

# Do the standard vlib / vmap / vcom for a questa library
# and put it a 'sim' folder in the module directory.
# Requires the modelsim.ini file with appropriate mappings in ../lib_block/modelsim.ini
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

# This will expand to `clean_lib_and`
# and is the phony target used for compiling a single block.
# Removed output products are:
# 1. the compiled library in ../lib_block/sim
.PHONY : $(CLEAN_TARGETS)
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(CLEAN_TARGETS) : clean_% : $$($$*_CLEAN_DEPS)
	@echo "~~ Cleaning $*  ~~"
	$(call echo_command, rm -rf ../$*/sim ../$*/modelsim.ini ../$*/work)


#################################################
##            ~~~ GRAVEYARD ~~~               ##
## Helpful, but currently unused code snippets ##
#################################################

# Alternative for Compiling file by file - The current mixed HDL method is more complicated but uses less vcom/vlog's
#		for i in $($*_COMPILE_ORDER); do
#			if [[ $$i == @(*.vhdl|*.vho|*.vhd) ]] ; then
#				$(call echo_command, vcom -work $(dir $@) $($*_VCOM_OPT) $$i)
#			else
#				$(call echo_command, vlog -work $(dir $@) $($*_VLOG_OPT) $$i)
#			fi
#		done
