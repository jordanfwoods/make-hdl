////////////////////////////////////////////////////////////////////////////////
// tb.sv = Testbench for lib_tb_a                                             //
// This module does the following:                                            //
// 1) Instantiates the and1.vhd and the and2.vhd and                          //
// 2) Runs an associated testcase with it.                                    //
//                                                                            //
// Manual Revision History                                                    //
// 12/13/24 - JFW - Initial Release                                           //
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////
// make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. //
// To view a copy of this license, visit                              //
// https://creativecommons.org/licenses/by-nc-sa/4.0/                 //
////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps

module tb();
   ////////////////
   // Parameters //
   ////////////////
   localparam bitwidth = 8;

   ////////////////////////
   // Signal Definitions //
   ////////////////////////
   logic [bitwidth-1:0] a, b, c;

   //////////////////////////////
   // Component Instantiations //
   //////////////////////////////

   and1 #(.G_WIDTH (bitwidth)) and1_inst(.a (a), .b (b), .c (c));

   ///////////////////////////////
   // Initial / Clocking Blocks //
   ///////////////////////////////

endmodule

