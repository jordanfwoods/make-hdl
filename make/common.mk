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
#############################################################
## HDL Buildfiles © 2025 by Jordan Woods is licensed under ##
## CC BY-NC-ND 4.0. To view a copy of this license, visit  ##
## https://creativecommons.org/licenses/by-nc-nd/4.0/      ##
#############################################################

# Fancy way of toggling verbosity.
ifeq ($(VERBOSE),)
V = @
VECHO = @\#
else
V =
VECHO = @echo
endif


