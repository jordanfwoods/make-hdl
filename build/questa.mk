##########################
# USER OVERWRITABLE VARS #
##########################

COMPILE_ORDER ?= hdl/*
HAS_TC        ?= no
VCOM_OPT      ?= -quiet -2008
VLOG_OPT      ?= -quiet -sv

####################
# UNTOUCHABLE VARS #
####################

BLOCK := $(notdir $(shell pwd))
$(BLOCK)_OUTS := sim/*

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


.PHONY: clean compile
clean:
	rm -rf work modelsim.ini sim

compile: comp_$(BLOCK)

##########################
# BLOCK SPECIFIC TARGETS #
##########################

.PHONY : comp_$(BLOCK)
comp_$(BLOCK) : $(BLOCK)_OUTS

.PHONY : $(BLOCK)_OUTS
$(BLOCK)_OUTS : sim

sim : $(COMPILE_ORDER)
	@echo "~~ Starting Compiling $(BLOCK)  ~~"
	vlib -quiet sim
	vmap -quiet work sim
	@for i in $(COMPILE_ORDER); do \
		echo "vcom -work sim $(VCOM_OPT) $$i" ; \
		vcom $(VCOM_OPT) $$i ; \
	done
	@echo "~~ Finishing Compiling $(BLOCK) ~~"


