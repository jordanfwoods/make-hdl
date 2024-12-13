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

HAS_TC        ?= no

####################
# UNTOUCHABLE VARS #
####################

BLOCK         ?= $(shell basename $(shell pwd))

##################
# GLOBAL TARGETS #
##################

ifeq ($(HAS_TC),no)
.PHONY: all
all: compile
else
.PHONY: all sim
all sim:
	@echo "Hello World from '$<' target!"
endif

.PHONY: clean
clean:
	$Vrm -rf work modelsim.ini sim

.PHONY: recursiveclean
recursiveclean:
ifdef $(BLOCK)_DEPS
	$Vrm -rf work modelsim.ini sim $(patsubst %,../%/sim, $($(BLOCK)_DEPENDENCY)) $(patsubst %,../%/modelsim.ini, $($(BLOCK)_DEPENDENCY))
else
	$Vrm -rf work modelsim.ini sim
endif

.PHONY: compile
compile: comp_$(BLOCK)

