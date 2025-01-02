Make-HDL
========

## License

This is not freely licensed for commercial use. If you have a need to use this in a commercial capacity, feel free to contact me via the email in my [github profile](https://github.com/jordanfwoods).

[make-hdl](https://github.com/jordanfwoods/make-hdl) © 2025 by [Jordan Woods](https://github.com/jordanfwoods) is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1).
<img style="float:right;height:22px" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt="">
<img style="float:right;height:22px" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt="">
<img style="float:right;height:22px" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt="">
<img style="float:right;height:22px" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt="">

## Overview

I got tired of VHDL / Verilog projects not compiling efficiently,
so I made a Makefile framework (with a tiny example design)
to show an example of efficient compilation.

This framework aims to do the following:

  * Simulation:
    * Uses **QUESTASIM** (free version) to compile HDL Libraries.
    * Compiles Libraries as **EFFICIENTLY** as possible.
    * Only recompiles libraries **AS NEEDED**.
    * Nothing recompiles **IF NO CHANGES**.
    * Running simulations / regressions are **PHONY** and will occur everytime.
        * This enables running same sims / regressions multiple times with the same seed.
  * Synthesis / Implementation **(TBD)**
    * Uses **VIVADO** (free version) to synthesize the simple example design.
    * Uses **NON-PROJECT MODE** to synthesize each block **OUT OF CONTEXT**, thus allowing us
      to avoid re-synthesizing everything.
    * Implementation cannot be sped up in a **GNU MAKE** style.
  * Generated HDL registers **(TBD)**
    * Uses **SystemRDL** files as single source of truth for HDL Registers.
    * **(TBD)** will be the SystemRDL compiler used.

## Table of contents
1. [**Framework Philosophy**](#philosophy)
    1. [**Expected Directory Structure**](#directory)
2. [**Necessary Make Targets**](#targets)
3. [**Necessary Make Variables**](#variables)
4. [**Example HDL Hierarchy**](#hierarchy)
5. [**Testing the Makefiles**](#testing)

## 1. Framework Philosophy <a name="philosophy"></a>

At a high level, each HDL Library is often referred to as a **BLOCK**, since many times
these libraries will have a top level entity / module (like a design sub-component, or BFM).

Since the same set of recipes must be run for each library, makefile templates have been written
so that each library only needs to source the relevant makefile templates and not recreate the
wheel / copy large portions of code for each libraries Makefile.

Each library **MUST** have a `<library_name>.mk` file in it's directory, but there is not necessarily
all that much in the `.mk` file. If the library depends on another library, then that libraries `.mk`
must be included. Other than that, the necessary make templates must be sourced. And if any of the default options need
to be updated (like the compile order, or compilation / synthesis options), those Make variables can be set here as well.

It is **STRONGLY** reccommended that each library also have it's own `Makefile`, so that compilation / synthesis can
occur for the individual libraries, as needed.

The hierarchy is expected to be **FLAT**, i.e. ALL library directories are stored at the `/hdl/` directory.

For complex designs that utilizes other repositories, those can called/referenced as submodules in their own directory within `/hdl/<lib_name>/hdl`.
The `<lib_name>_COMPILE_ORDER` Make variable will almost definitely need to be explicitly defined. This example repo has used the OSVVM github project as an example.

### i. Expected Directory Structure <a name="directory"></a>

The directory structure is designed to be as flat as possible. each library is in it's own folder within `hdl`. It also will have it's own `hdl` directory containing
all of the VHDL / Verilog for the library. Each folder needs its own `.mk` file, and likely, its own `Makefile`.

```
├── hdl
│   ├── < lib_1_name >
│   │   ├── hdl/
│   │   │   ├── < hdl_file_1 >.vhd
│   │   │   ├── < hdl_file_2 >.sv
│   │   │   ├── ...
│   │   │   └── < hdl_file_n >.sv
│   │   ├── < lib_1_name >.mk
│   │   ├── Makefile
│   ├── < lib_2_name >
│   │   ├── ...
│   ├── ...
│   ├── < lib_n_name >
│   │   ├── hdl/
│   │   │   ├── < hdl_file_1 >.vhd
│   │   │   ├── < hdl_file_2 >.sv
│   │   │   ├── ...
│   │   │   └── < hdl_file_n >.sv
│   │   ├── < lib_n_name >.mk
│   │   ├── Makefile
├── make
│   ├── questa
│   │   ├── questa.mk
│   │   └── questa_blocks.mk
│   └── common.mk
└── Makefile
```

### ii. Example `Makefile` and `<library>.mk` files.
`<library>.mk`  :
```make
include ../osvvm/osvvm.mk

BLOCK := lib_and
$(BLOCK)_DEPENDENCY := osvvm
# Specifying the compile order is not necessary, unless the files cannot be
# compiled in alphabetical order.
$(BLOCK)_COMPILE_ORDER := ../$(BLOCK)/hdl/and1.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/and2.vhd

include ../../make-hdl/questa/questa_blocks.mk
```

`Makefile`  :
```make
include ../lib_and/and.mk
include ../../make-hdl/questa/questa.mk
```
## 2. Necessary Make Targets <a name="targets"></a>

`.PHONY` targets that are very helpfule to know.

Questasim   :
  * all (simulate, if the library has test cases, else compile)
  * comp_\<library> (can reference current library or any dependent library)
  * compile (same as comp_\<current library>)
  * sim / simulate
  * clean_\<library> (can reference current library or any dependent library)
  * clean (same as clean_\<current library>)

## 3. Necessary Make Variables <a name="variables"></a>

```make
# if unspecified, just grab everything in the hdl folder.
$(BLOCK)_COMPILE_ORDER ?= $(wildcard ../$(BLOCK)/hdl/*)
# names of libraries this block is dependent on.
$(BLOCK)_DEPENDENCY    ?=
# If this is a testbench with testcases, allow for 'vsim'
$(BLOCK)_HAS_TC        ?= no
# VHDL Compile options
$(BLOCK)_VCOM_OPTS     ?= -quiet -2008
# Verilog Compile options
$(BLOCK)_VLOG_OPTS     ?= -quiet -sv
# Questa Simulation options
$(BLOCK)_VSIM_OPTS     ?=
# Testbench top-level for simulatable libraries
$(BLOCK)_TB_TOP        ?= tb
# Library has a mix of VHDL and Verilog.
$(BLOCK)_MIXED_HDL     ?=
```

## 4. Example HDL Hierarchy <a name="hierarchy"></a>

```
─── lib_tb_a.tb
    └── lib_and.and1
        └── osvvm.AlertLogPkg
```

## 5. Testing the Makefiles <a name="testing"></a>

***TBD***

