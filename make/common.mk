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

######################
## REGRESSION STUFF ##
######################

# These routines are needed by the top-level Makefile, AND each HDL library that has
# testcases, so the functions are here for now.

define setup_regression
	@echo -e "\n~~ Regression Results ~~"
	result="#Library #Testcase Name #Errors #Warnings #\n"
	result+="#------- #------------- #------ #-------- #\n"
endef

define compile_regression
	for j in $(3); do
		tmp=`tail -n 1 $(2)/$$j.log | grep "# Errors: "`
		errors=`echo $$tmp | sed 's@# Errors: \([0-9]\+\).*@\1@'`
		warn=`echo  $$tmp | sed 's@# Errors: .*, Warnings: \([0-9]\+\).*@\1@'`
		((error_cnt+=errors))
		((warn_cnt+=warn))
		result+="#$(1) #$$j #$$errors #$$warn #\n"
	done
endef

define finish_regression
	result+="#------- #------------- #------ #-------- #\n"
	echo -e $$result | column -t -s '#' -o '| '
	echo "REGRESSION RESULTS: `echo $(REGRESSION_LIST) | wc -w` tests run with $$error_cnt errors and $$warn_cnt warnings found!"
	if [ $$error_cnt -eq 0 ] ; then
		echo -e "REGRESSION PASSED!\n~~ End of Regression Results! ~~\n"
	else
		echo -e "REGRESSION FAILED!\n~~ End of Regression Results! ~~\n"
		exit 1;
	fi
endef

