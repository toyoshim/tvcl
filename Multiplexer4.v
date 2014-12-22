// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module Multiplexer4(
    i_data0,
    i_data1,
    i_data2,
    i_data3,
    i_select0,
    i_select1,
    i_select2,
    i_select3,
    o_data,
    o_error);
  parameter width = 1;

  input  [width - 1:0] i_data0;
  input  [width - 1:0] i_data1;
  input  [width - 1:0] i_data2;
  input  [width - 1:0] i_data3;
  input                i_select0;
  input                i_select1;
  input                i_select2;
  input                i_select3;

  output [width - 1:0] o_data;
  output               o_error;

  wire   [        2:0] w_sum;

  assign o_data  = i_select0 ? i_data0 :
                   i_select1 ? i_data1 :
                   i_select2 ? i_data2 :
                   i_select3 ? i_data3 : 0;
  assign w_sum   = i_select0 + i_select1 + i_select2 + i_select3;
  assign o_error = w_sum[2] | w_sum[1] | (w_sum == 3'h0);
endmodule  // Multiplexer4
