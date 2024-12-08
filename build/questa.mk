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
	rm -rf work modelsim.ini sim

.PHONY: compile
compile: $($(BLOCK)_OUTS)

