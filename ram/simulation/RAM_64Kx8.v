// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module RAM_64Kx8(
    i_addr,
    i_enable_x,
    i_write_x,
    i_data,
    o_data);
  input  [15:0] i_addr;
  input         i_enable_x;
  input         i_write_x;
  input  [ 7:0] i_data;
  output [ 7:0] o_data;

  RAM #(.width(8),
        .depth(16)) ram(
      .i_addr    (i_addr    ),
      .i_enable_x(i_enable_x),
      .i_write_x (i_write_x ),
      .i_data    (i_data    ),
      .o_data    (o_data    ));
endmodule  // module RAM_64Kx8
