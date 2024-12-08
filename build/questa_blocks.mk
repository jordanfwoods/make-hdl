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
$(BLOCK)_DEPS          := $(patsubst %, ../%/sim, $($(BLOCK)_DEPENDENCY))

##########################
# BLOCK SPECIFIC TARGETS #
##########################

.PHONY : comp_%
comp_$(BLOCK) : $($(BLOCK)_DEPS) $($(BLOCK)_OUTS)
	@echo "JQZU $@ $^ $%_DEPS"

# $($(BLOCK)_OUTS) : $($(BLOCK)_DEPS) $($(BLOCK)_COMPILE_ORDER)
$($(BLOCK)_OUTS) : $($(BLOCK)_COMPILE_ORDER)
	@echo "$(BLOCK)"
	@echo "~~ Starting Compiling $(BLOCK)  ~~" ; \
	echo "vlib -quiet $($(BLOCK)_OUTS)" ; \
	vlib -quiet $($(BLOCK)_OUTS) ; \
	rc1=$$? ; \
	echo "vmap -quiet work $($(BLOCK)_OUTS)" ; \
	vmap -quiet work $($(BLOCK)_OUTS) ; \
	rc2=$$? ; \
	for i in $($(BLOCK)_COMPILE_ORDER); do \
		if [[ $$i == *.vhd ]]; then \
			echo "vcom -work $($(BLOCK)_OUTS) $($(BLOCK)_VCOM_OPT) $$i" ; \
			vcom -work $($(BLOCK)_OUTS) $($(BLOCK)_VCOM_OPT) $$i ; \
		else \
			echo "vlog -work $($(BLOCK)_OUTS) $($(BLOCK)_VLOG_OPT) $$i" ; \
			vlog -work $($(BLOCK)_OUTS) $($(BLOCK)_VLOG_OPT) $$i ; \
		fi ; \
		rc3=$$? ; \
		if [ $$rc3 -ne 0 ]; then break ; fi \
	done ; \
	if [[ $$rc1 -eq 0 && $$rc2 -eq 0 && $$rc3 -eq 0 ]]; then \
		echo "~~ Finishing Compiling $(BLOCK) ~~" ; \
	else \
		rm -rf work $($(BLOCK)_OUTS) modelsim.ini; \
		echo "~~ Error Compiling $(BLOCK). Removing libs ~~" ; \
	fi

