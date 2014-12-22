// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module EvenParityChecker(
    i_data,
    i_parity,
    o_error);
  parameter width = 1;

  input  [width - 1:0] i_data;
  input                i_parity;
  output               o_error;

  assign o_error = ^{ i_data, i_parity };
endmodule  // EvenParityGenerator
