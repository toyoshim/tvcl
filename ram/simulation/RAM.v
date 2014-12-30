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
  parameter delay = 10;
  parameter depth = 16;
  parameter width = 8;
  input  [depth - 1:0] i_addr;
  input                i_enable_x;
  input                i_write_x;
  input  [width - 1:0] i_data;
  output [width - 1:0] o_data;
  reg    [width - 1:0] o_data;

  reg    [width - 1:0] r_ram[0:2**depth];

  reg    [depth - 1:0] r_addr;
  reg                  r_enable_x;
  reg                  r_write_x;
  reg    [width - 1:0] r_data;

  always r_addr     = #delay i_addr;
  always r_enable_x = #delay i_enable_x;
  always r_write_x  = #delay i_write_x;
  always r_data     = #delay i_data;

  always @ (r_addr or r_enable_x or r_write_x or r_data) begin
    if (r_enable_x) begin
      o_data <= {width{1'bz}};
    end else if (r_write_x) begin
      o_data <= r_ram[r_addr];
    end else begin
      o_data <= {width{1'bx}};
      r_ram[r_addr] <= r_data;
    end
  end
endmodule  // module RAM
