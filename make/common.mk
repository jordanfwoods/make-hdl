################################################################################
## common.mk = Common Make concepts used by all template files                ##
## This module does the following:                                            ##
## 1) Creates common variables, rules, and functions used by all make         ##
##    templates.                                                              ##
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

VERBOSE ?=

# Fancy way of toggling verbosity.
ifeq ($(VERBOSE),)
V = @
VECHO = @\#
else
V =
VECHO = @echo
endif

# Since we abuse .ONESHELL, it only looks at the first line's '@'
# Therefore, let's just make a little utility to toggle verbosity
define echo_command
	$(VECHO) "$(1)"
	$(1)
endef

############################
## Performance Monitoring ##
############################

REPORT_TIME ?=
ifeq ($(REPORT_TIME),)
define end_time
endef
else
define end_time
	$(if $(filter $@, $(_LAST_TARGET_)), $(call end_time_calc))
endef
endif

define end_time_calc
	$(eval __END_TIME__  := $(shell date +%s.%3N))
	$(eval _L_  := $(shell echo $(__END_TIME__)-$(__START_TIME__)|bc))
	$(eval _L0_ := $(shell echo 0$(_L_) | sed 's/\..*//'))
	echo "~~ Time Statistics ~~"
	echo "Finished targets : $(_ALL_GOALS_)"
	if   [ "$(_L0_)" -ge "86400" ] ; then
		echo "Time Elapsed     : $(shell echo $(_L_)/60/60/24 | bc) days $(shell echo $(_L_)/60/60%24 | bc) hours $(shell echo $(_L_)/60%60 | bc) minutes, $(shell echo $(_L_)%60 | bc | awk '{printf "%.4f\n",$$0}') seconds"
	elif [ "$(_L0_)" -ge "3600" ] ; then
		echo "Time Elapsed     : $(shell echo $(_L_)/60/60%24 | bc) hours $(shell echo $(_L_)/60%60 | bc) minutes, $(shell echo $(_L_)%60 | bc | awk '{printf "%.4f\n",$$0}') seconds"
	elif [ "$(_L0_)" -ge "60" ] ; then
		echo "Time Elapsed     : $(shell echo $(_L_)/60%60 | bc) minutes, $(shell echo $(_L_)%60 | bc | awk '{printf "%.4f\n",$$0}') seconds"
	else
		echo "Time Elapsed     : $(shell echo $(_L_)%60 | bc | awk '{printf "%.4f\n",$$0}') seconds"
	fi
	echo "~~ End of Time Statistics ~~"
	echo
endef

$(eval __START_TIME__ :=$(shell date +%s.%3N))

ifeq (,$(MAKECMDGOALS))
$(eval _LAST_TARGET_  := all)
$(eval _ALL_GOALS_    := all)
else
$(eval _LAST_TARGET_  := $(lastword $(MAKECMDGOALS)))
$(eval _ALL_GOALS_    := $(MAKECMDGOALS))
endif

######################
## REGRESSION STUFF ##
######################

# These routines are needed by the top-level Makefile, AND each HDL library that has
# testcases, so the functions are here for now.

define setup_regression
	@echo -e "\n~~ Regression Results ~~"
	result="Library #Testcase Name #Errors #Warnings\n"
	result+="--------#--------------#-------#---------\n"
endef

define compile_regression
	for j in $(3); do
		tmp=`tail -n 1 $(2)/$$j.log | grep "# Errors: "`
		errors=`echo $$tmp | sed 's@# Errors: \([0-9]\+\).*@\1@'`
		warn=`echo  $$tmp | sed 's@# Errors: .*, Warnings: \([0-9]\+\).*@\1@'`
		((error_cnt+=errors))
		((warn_cnt+=warn))
		result+="$(1) #$$j #$$errors #$$warn\n"
	done
endef

define finish_regression
	result+="--------#--------------#-------#---------\n"
	result+="`echo $(1) | wc -w` Libs #`echo $(2) | wc -w` Tests #$$error_cnt#$$warn_cnt\n"
	echo -e $$result | column -t -s '#' -o '| '
	echo "REGRESSION RESULTS: `echo $(2) | wc -w` tests run with $$error_cnt errors and $$warn_cnt warnings found!"
	if [ $$error_cnt -eq 0 ] ; then
		echo -e "REGRESSION PASSED!\n~~ End of Regression Results! ~~\n"
		$(call end_time)
	else
		echo -e "REGRESSION FAILED!\n~~ End of Regression Results! ~~\n"
		$(call end_time)
		exit 1;
	fi
endef

