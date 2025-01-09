################################################################################
## vivado.mk = Phony Make Rules for HDL Blocks for vivado                     ##
## This module does the following:                                            ##
## 1) Sets the following questasim make rules:                                ##
##    all, synth, synth_ip, synth_ip_<ip>, clean, etc.                        ##
##                                                                            ##
## Manual Revision History                                                    ##
## 01/07/25 - JFW - Initial Release                                           ##
################################################################################
##
########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################

include ../../make-hdl/common.mk

####################
# PRE-DEFINED VARS #
####################

$(eval TCLLIST     := $(shell find . -iname "*.tcl"))
$(eval IPLIST      := $(basename $(notdir $(TCLLIST))))
$(eval SYNTHIPLIST := $(patsubst %,synth_ip_%,$(IPLIST)))
$(eval DCPIPLIST   := $(sort $(foreach i,$(IPLIST),$i/$i.dcp)))

VIVADO_LOGS := -journal logs/vivado.jou -log logs/vivado.log


####################################
# PRE-DEFINED ROUTINES / FUNCTIONS #
####################################

_pos = $(if $(findstring $1,$2),$(call _pos,$1,\
       $(wordlist 2,$(words $2),$2),x $3),$3)
pos  = $(words $(call _pos,$1,$2))
ip_name = $(word $(shell echo $(call pos,$1,$2)+1 | bc),$2)

# look for all lines in the journal that start with create_ip and assume the user wants the last one.
define save_tcl_command
	cat logs/vivado.jou | grep -e "^$(strip $1)" | tail -1
endef
__first__ = grep -ne "^create_ip"       logs/vivado.jou | cut -f1 -d:
__last__  = grep -ne "^generate_target" logs/vivado.jou | cut -f1 -d:
new_dir = $(subst $(word $(shell echo $(call pos,dir,$1)+1|bc),$1),$2,$1)

######################
## GNU MAKE Options ##
######################

# all lines of recipe happen in one shell instance to make writing the recipes easier.
.ONESHELL:

##################
# GLOBAL TARGETS #
##################

.PHONY: synth
synth: $(SYNTHIPLIST) ;

.PHONY: clean
clean:
	rm -rf logs .Xil .cache vivado*.log vivado*.jou $(IPLIST)

.PHONY: new_ip
new_ip: | logs
	@vivado $(call VIVADO_LOGS) -source ../../make-hdl/vivado/tcl/empty_project.tcl
	#Get filename of TCL script to check in.
	TCL=`cat logs/vivado.jou | grep -e "^create_ip" | tail -1 | sed -e 's/.*-module_name //' -e 's/\s.*//'`
	TCLFILE=$$TCL.tcl
	#Assemble amazing TCL script
	echo "~~ Creating $$TCLFILE ~~"
	echo "create_project -in_memory -part xc7a12ticsg325-1L" > $$TCLFILE
	if [ "`$(__first__)`" ] ; then sed -n  "`$(__first__)`,`$(__last__)`p" logs/vivado.jou >> $$TCLFILE ; fi
	echo "if { [string compare [lindex $$argv 0] \"nosynth\"] != 0 } { synth_ip [get_ips] }" >> $$TCLFILE
	echo "close_project" >> $$TCLFILE
	# Fix the directories
	sed -i "s#$$(dirname $$PWD)#.#" $$TCLFILE

logs:
	@mkdir -p logs

#####################
# IP Pattern Rules ##
#####################

.PHONY: synth_ip_%
.SECONDEXPANSION : # Allow for funny business like double $ in the dependency list
$(SYNTHIPLIST): synth_ip_% : %/$$*.dcp

$(DCPIPLIST): %.dcp: | logs
	@module=$$(basename $*)
	echo "~~ Compiling $(notdir $(shell pwd)).$$module ~~"
	vivado $(VIVADO_LOGS) -mode batch -source `echo $(TCLLIST) | grep -o "[^ ]*\$${module}[^ ]*"`

