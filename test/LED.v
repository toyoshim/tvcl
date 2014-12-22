// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module LEDTest;
  wire       w_a;
  wire       w_b;
  wire       w_c;
  wire       w_d;
  wire       w_e;
  wire       w_f;
  wire       w_g;
  wire       w_dp;

  reg        clk;
  reg        rst_x;

  always #1 clk = ~clk;

  LED dut(
      .clk  (clk  ),
      .rst_x(rst_x),
      .o_a  (w_a  ),
      .o_b  (w_b  ),
      .o_c  (w_c  ),
      .o_d  (w_d  ),
      .o_e  (w_e  ),
      .o_f  (w_f  ),
      .o_g  (w_g  ),
      .o_dp (w_dp ));

  initial begin
    #18
    forever begin
      #2
      $strobe("%b", w_a,
              "%b", w_b,
              "%b", w_c,
              "%b", w_d,
              "%b", w_e,
              "%b", w_f,
              "%b", w_g,
              "%b", w_dp);
    end
  end

  initial begin
    //$dumpfile("LED.vcd");
    //$dumpvars(0, dut);
    #10
    clk   <= 1'b0;
    rst_x <= 1'b0;
    #10
    rst_x <= 1'b1;
    #100
    $finish;
  end  // initial

endmodule  // LEDTest
