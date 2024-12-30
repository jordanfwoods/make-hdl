Make-HDL
========

I got tired of VHDL / Verilog projects not compiling efficiently,
so I made a Makefile framework (with a tiny example design)
to show an example of efficient compilation.

This framework aims to do the following:

  * Simulation:
    * Uses `QUESTASIM` (free version) to compile HDL Libraries.
    * Compiles Libraries as `EFFICIENTLY` as possible.
    * Only recompiles libraries `AS NEEDED`.
    * Nothing recompiles `IF NO CHANGES`.
    * Running simulations / regressions are `PHONY` and will occur everytime.
        * This enables running same sims / regressions multiple times with the same seed.
  * Synthesis / Implementation `(TBD)`
    * Uses `VIVADO` (free version) to synthesize the simple example design.
    * Uses `NON-PROJECT MODE` to synthesize each block `OUT OF CONTEXT`, thus allowing us
      to avoid re-synthesizing everything.
    * Implementation cannot be sped up in a `GNU MAKE` style.
  * Generated HDL registers `(TBD)`
    * Uses `SystemRDL` files as single source of truth for HDL Registers.
    * `(TBD)` will be the SystemRDL compiler used.

## Table of contents
1. [**Framework Philosophy**](#philosophy)
    a. [**Expected Directory Structure**](#directory)
2. [**Necessary Make Targets**](#targets)
3. [**Necessary Make Variables**](#variables)
4. [**Example HDL Hierarchy**](#hierarchy)
5. [**Testing the Makefiles**](#testing)

### Framework Philosophy <a name="philosophy"></a>

--------  -----------------------
keyword   text
--------  -----------------------
red       Sunsets, apples, and
          other red or reddish
          things.

green     Leaves, grass, frogs
          and other things it's
          not easy being.
--------  -----------------------

A horizontal rule follows.

***

Here's a definition list:

apples
  : Good for making applesauce.
oranges
  : Citrus!
tomatoes
  : There's no "e" in tomatoe.

#### Expected Directory Structure <a name="directory"></a>

### Necessary Make Targets <a name="targets"></a>

### Necessary Make Variables <a name="variables"></a>

### Example HDL Hierarchy <a name="hierarchy"></a>

### Testing the Makefiles <a name="testing"></a>

