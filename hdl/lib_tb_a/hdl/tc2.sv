////////////////////////////////////////////////////////////////////////////////
// tc2.sv = Testbench for lib_tb_a                                            //
// This module does the following:                                            //
// 1) Instantiates the tb.sv                                                  //
// 2) Initializes the inputs (a & b) to 0.                                    //
// 3) Asserts an Error and a Fatal, to test the regression.                   //
//                                                                            //
// Manual Revision History                                                    //
// 12/30/24 - JFW - Initial Release                                           //
////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////
// HDL Buildfiles © 2025 by Jordan Woods is licensed under //
// CC BY-NC-ND 4.0. To view a copy of this license, visit  //
// https://creativecommons.org/licenses/by-nc-nd/4.0/      //
/////////////////////////////////////////////////////////////

`timescale 1ps / 1ps

module tc2();

   ////////////////
   // Parameters //
   ////////////////

   ////////////////////////
   // Signal Definitions //
   ////////////////////////

   //////////////////////////////
   // Component Instantiations //
   //////////////////////////////

   tb #() tb();

   ///////////////////
   // Initial Block //
   ///////////////////

   initial begin
      tb.a = 0;
      tb.b = 0;
      #1ns;
      $error("You suck at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",tb.a,tb.b,tb.c,tb.a&tb.b);
   end // initial

endmodule

