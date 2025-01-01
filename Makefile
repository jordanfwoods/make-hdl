########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################

# necessary inclusions
include make/common.mk
include hdl/lib_tb_a/regression_list.mk

# necessary make options
.ONESHELL:
.PHONY: all regression run_regressions clean

# define the libraries that have regressions to run
REGRESSION_LIBS := lib_tb_a

# all target is empty and just has dependencies (regression / bitfile).
all: regression ;

# The regression target just compiles the results, it's dependency actually runs the sims
regression: run_regressions
	@$(call setup_regression)
	$(foreach i, $(REGRESSION_LIBS), $(call compile_regression,$i,hdl/$(strip $i)/results,$($i_REGRESSION_LIST)) ; )
	$(foreach i, $(REGRESSION_LIBS), $(eval TMP_LIST+=$($i_REGRESSION_LIST)))
	$(call finish_regression,$(REGRESSION_LIBS),$(TMP_LIST))

# The run_regressions target loops through each library in the regression, and runs their regression targets.
# NOTE: This is one of, if not the only time recursive make is used!
run_regressions:
	@for i in $(REGRESSION_LIBS); do
		echo "~~ Starting $$i Regression ~~"
		make -sC hdl/$$i run_regression_list
	done
	: # Ensure this recipe doesn't end on an error

# Call recursive make for libraries relevant to our top-level Makefile.
# NOTE: This is one of, if not the only time recursive make is used!
clean:
	@for i in $(REGRESSION_LIBS); do
		make -sC hdl/$$i recursiveclean
	done

