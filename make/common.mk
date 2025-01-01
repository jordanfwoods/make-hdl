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
