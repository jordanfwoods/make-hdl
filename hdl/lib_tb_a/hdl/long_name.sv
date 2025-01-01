////////////////////////////////////////////////////////////////////////////////
// long_name.sv = Testbench for lib_tb_a                                      //
// This module does the following:                                            //
// 1) Instantiates the tb.sv                                                  //
// 2) Initializes the inputs (a & b) to 0.                                    //
// 3) Asserts an Error and a Fatal, to test the regression.                   //
//                                                                            //
// Manual Revision History                                                    //
// 12/30/24 - JFW - Initial Release                                           //
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////
// make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. //
// To view a copy of this license, visit                              //
// https://creativecommons.org/licenses/by-nc-sa/4.0/                 //
////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps

module long_name();

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
      logic [7:0] rand_val;
      rand_val = $random();
      tb.a = 0;
      tb.b = 0;
      #1ns;
      for (int i=0; i<rand_val; i++)
         $error("You suck at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",tb.a,tb.b,tb.c,tb.a&tb.b);
   end // initial

endmodule

