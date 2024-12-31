////////////////////////////////////////////////////////////////////////////////
// tc1.sv = Testbench for lib_tb_a                                            //
// This module does the following:                                            //
// 1) Instantiates the tb.sv                                                  //
// 2) Updates the inputs (a & b), waits two seconds, and verifies the result  //
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

module tc1();

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
      for (int i=0; i<50; i++) begin
         tb.a = $random();
         tb.b = $random();
         #2ns;
         if (tb.c == (tb.a&tb.b))
            $display("You ROCK at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",tb.a,tb.b,tb.c,tb.a&tb.b);
         else begin
            $error("You suck at AND-ing. a: %2x, b: %2x, c: %2x, expected: %2x",tb.a,tb.b,tb.c,tb.a&tb.b);
            $fatal(1, "AND module failed to properly execute bitwise and logic");
         end // if c==a&b
      end // for i 0:49
      $display("Finished the tc1 test. All 50 iterations PASSED!");
      $finish();
   end // initial

endmodule

