// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 1ns/100ps

module RAM(
    i_addr,
    i_enable_x,
    i_write_x,
    i_data,
    o_data);
  parameter depth = 16;
  parameter width = 8;
  input  [depth - 1:0] i_addr;
  input                i_enable_x;
  input                i_write_x;
  input  [width - 1:0] i_data;
  output [width - 1:0] o_data;
  reg    [width - 1:0] o_data;

  reg    [width - 1:0] r_ram[0:2**depth];

  always @ (i_addr or i_enable_x or i_write_x or i_data) begin
    if (i_enable_x) #10 begin
      o_data <= {width{1'bz}};
    end else if (i_write_x) #10 begin
      o_data <= r_ram[i_addr];
    end else #10 begin
      o_data <= {width{1'bx}};
      r_ram[i_addr] <= i_data;
    end
  end
endmodule  // module RAM
