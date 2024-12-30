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
/////////////////////////////////////////////////////////////
// HDL Buildfiles © 2025 by Jordan Woods is licensed under //
// CC BY-NC-ND 4.0. To view a copy of this license, visit  //
// https://creativecommons.org/licenses/by-nc-nd/4.0/      //
/////////////////////////////////////////////////////////////

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

   ///////////////////
   // Initial Block //
   ///////////////////

   initial begin
      for (int i=0; i<50; i++) begin
         a = $random();
         b = $random();
         #2ns;
         if (c == (a&b))
            $display("You ROCK at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",a,b,c,a&b);
         else begin
            $error("You suck at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",a,b,c,a&b);
            $fatal(1, "AND module failed to properly execute bitwise and logic");
         end // if c==a&b
      end // for i 0:49
      $display("Finished the lib_tb_a test. All 50 iterations PASSED!");
      $finish();
   end // initial

endmodule

