##########################
# USER OVERWRITABLE VARS #
##########################

$(BLOCK)_COMPILE_ORDER ?= ../$(BLOCK)/hdl/*
$(BLOCK)_DEPENDENCY    ?=
$(BLOCK)_HAS_TC        ?= no
$(BLOCK)_VCOM_OPT      ?= -quiet -2008
$(BLOCK)_VLOG_OPT      ?= -quiet -sv

####################
# UNTOUCHABLE VARS #
####################

$(BLOCK)_OUTS          := ../$(BLOCK)/sim
$(BLOCK)_DEPS          := $(patsubst %,../%/sim,$($(BLOCK)_DEPENDENCY))

##########################
# BLOCK SPECIFIC TARGETS #
##########################

.NOTINTERMEDIATE:

.PHONY : comp_%
.SECONDEXPANSION :
comp_% : ../%/modelsim.ini ../%/sim ;

.SECONDEXPANSION:
../%/modelsim.ini : $$($$*_DEPS)
	@for i in $($*_DEPENDENCY); do \
		echo vmap -quiet $$i ../$$i/sim ; \
		vmap -quiet $$i ../$$i/sim ; \
	done
	
.SECONDEXPANSION:
../%/sim : $$($$*_COMPILE_ORDER) 
	@echo "~~ Starting Compiling $*  ~~" ; \
	cd ../$* ; \
	echo "vlib -quiet $@" ; \
	vlib -quiet $@ ; \
	rc1=$$? ; \
	echo "vmap -quiet work $@" ; \
	vmap -quiet work $@ ; \
	rc2=$$? ; \
	for i in $^; do \
		if [[ $$i == *.vhd ]]; then \
			echo "vcom -work $@ $($*_VCOM_OPT) $$i" ; \
			vcom -work $@ $($*_VCOM_OPT) $$i ; \
		else \
			echo "vlog -work $@ $($*_VLOG_OPT) $$i" ; \
			vlog -work $@ $($*_VLOG_OPT) $$i ; \
		fi ; \
		rc3=$$? ; \
		if [ $$rc3 -ne 0 ]; then break ; fi \
	done ; \
	if [[ $$rc1 -eq 0 && $$rc2 -eq 0 && $$rc3 -eq 0 ]]; then \
		echo "~~ Finishing Compiling $* ~~" ; \
	else \
		rm -rf work $@ modelsim.ini ; \
		echo "~~ Error Compiling $*. Removing libs ~~" ; \
	fi ; \
	cd - > /dev/null

