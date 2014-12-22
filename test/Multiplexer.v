// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module MultiplexerTest;
  wire [2:0] w_data;
  wire       w_error;
  reg  [3:0] r_select;
  reg        r_disable_error_check;
  reg        r_error;

  Multiplexer4 #(.width(3)) mux(
      .i_data0  (3'b001     ),
      .i_data1  (3'b010     ),
      .i_data2  (3'b011     ),
      .i_data3  (3'b100     ),
      .i_select0(r_select[0]),
      .i_select1(r_select[1]),
      .i_select2(r_select[2]),
      .i_select3(r_select[3]),
      .o_data   (w_data     ),
      .o_error  (w_error    ));

  always @ (w_error or r_error) begin
    if (w_error & !r_disable_error_check) begin
      $display("unexpected error");
    end
    if (r_error) begin
      $display("wrong data is selected");
    end
  end

  initial begin
    //$dumpfile("Multiplexer.vcd");
    //$dumpvars(0, mux);
    r_disable_error_check <= 1'b0;
    r_error               <= 1'b0;
    r_select              <= 4'b0001;
    #1
    r_error               <= w_data != 3'b001;
    #1
    r_select              <= 4'b0010;
    #1
    r_error               <= w_data != 3'b010;
    #1
    r_select              <= 4'b0100;
    #1
    r_error               <= w_data != 3'b011;
    #1
    r_select              <= 4'b1000;
    #1
    r_error               <= w_data != 3'b100;
    #1
    r_disable_error_check <= 1'b1;
    #1
    r_select              <= 4'b0011;
    #1
    r_error               <= w_error != 1'b1;
    #1
    r_select              <= 4'b0000;
    #1
    r_error               <= w_error != 1'b1;
    #1
    $finish;
  end
endmodule  // MultiplexerTest
