// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module ParityTest;
  wire       w_parity_e1;
  wire       w_parity_e8;
  wire       w_parity_o1;
  wire       w_parity_o8;
  wire       w_error_e1;
  wire       w_error_e8;
  wire       w_error_o1;
  wire       w_error_o8;

  reg  [7:0] r_data;

  integer    i;

  EvenParityGenerator parity_generator_e1(r_data[0], w_parity_e1);
  EvenParityGenerator #(.width(8)) parity_generator_e8(r_data, w_parity_e8);
  EvenParityChecker parity_checker_e1(r_data[0], w_parity_e1, w_error_e1);
  EvenParityChecker #(.width(8)) parity_checker_e8(
      r_data, w_parity_e8, w_error_e8);
  OddParityGenerator parity_generator_o1(r_data[0], w_parity_o1);
  OddParityGenerator #(.width(8)) parity_generator_o8(r_data, w_parity_o8);
  OddParityChecker parity_checker_o1(r_data[0], w_parity_o1, w_error_o1);
  OddParityChecker #(.width(8)) parity_checker_o8(
      r_data, w_parity_o8, w_error_o8);

  always @ (w_error_e8 or w_error_e1 or w_error_o8 or w_error_o1) begin
    if (w_error_e8 == 1'b1) begin
      $display("parity error on e8");
    end
    if (w_error_e1 == 1'b1) begin
      $display("parity error on e1");
    end
    if (w_error_o8 == 1'b1) begin
      $display("parity error on o8");
    end
    if (w_error_o1 == 1'b1) begin
      $display("parity error on o1");
    end
    if (w_parity_e1 == w_parity_o1) begin
      $display("1-bit even and odd parities are the same unexpectedly");
    end
    if (w_parity_e8 == w_parity_o8) begin
      $display("8-bit even and odd parities are the same unexpectedly");
    end
  end

  initial begin
    //$dumpfile("Parity.vcd");
    //$dumpvars(0, parity_generator_e8);
    r_data <= 8'h00;
    #1
    r_data <= 8'h11;
    #1
    r_data <= 8'h08;

    for (i = 0; i < 256; i = i + 1) begin
      #1
      r_data <= i;
    end
    #1
    $finish;
  end
endmodule  // ParityTest
