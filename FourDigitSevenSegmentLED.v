// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module FourDigitSevenSegmentLED(
    clk,
    rst_x,
    i_data3,
    i_data2,
    i_data1,
    i_data0,
    i_dp3,
    i_dp2,
    i_dp1,
    i_dp0,
    o_a,
    o_b,
    o_c,
    o_d,
    o_e,
    o_f,
    o_g,
    o_dp,
    o_select,
    o_error);
  input        clk;
  input        rst_x;

  input  [3:0] i_data3;
  input  [3:0] i_data2;
  input  [3:0] i_data1;
  input  [3:0] i_data0;
  input        i_dp3;
  input        i_dp2;
  input        i_dp1;
  input        i_dp0;

  output       o_a;
  output       o_b;
  output       o_c;
  output       o_d;
  output       o_e;
  output       o_f;
  output       o_g;
  output       o_dp;
  output [3:0] o_select;
  output       o_error;

  wire   [3:0] w_data;
  wire         w_data_error;
  wire         w_dp_error;

  reg    [3:0] r_select;

  assign o_select = r_select;
  assign o_error  = w_data_error | w_dp_error;

  always @ (posedge clk or negedge rst_x) begin
    if (!rst_x) begin
      r_select <= 4'b1110;
    end else begin
      r_select <= { r_select[2:0], r_select[3] };
    end
  end

  Multiplexer4 #(.width(4)) mux_data(
      .i_data0  (i_data0     ),
      .i_data1  (i_data1     ),
      .i_data2  (i_data2     ),
      .i_data3  (i_data3     ),
      .i_select0(!r_select[0]),
      .i_select1(!r_select[1]),
      .i_select2(!r_select[2]),
      .i_select3(!r_select[3]),
      .o_data   (w_data      ),
      .o_error  (w_data_error));

  Multiplexer4 mux_dp(
      .i_data0  (i_dp0       ),
      .i_data1  (i_dp1       ),
      .i_data2  (i_dp2       ),
      .i_data3  (i_dp3       ),
      .i_select0(!r_select[0]),
      .i_select1(!r_select[1]),
      .i_select2(!r_select[2]),
      .i_select3(!r_select[3]),
      .o_data   (o_dp        ),
      .o_error  (w_dp_error  ));

  SevenSegmentLED led(
      .i_data   (w_data      ),
      .o_a      (o_a         ),
      .o_b      (o_b         ),
      .o_c      (o_c         ),
      .o_d      (o_d         ),
      .o_e      (o_e         ),
      .o_f      (o_f         ),
      .o_g      (o_g         ));
endmodule  // FourDigitSevenSegmentLED

