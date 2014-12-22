// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module OddParityGenerator(
    i_data,
    o_parity);
  parameter width = 1;

  input  [width - 1:0] i_data;
  output               o_parity;

  assign o_parity = ^{ i_data, 1'b1 };
endmodule  // OddParityGenerator
