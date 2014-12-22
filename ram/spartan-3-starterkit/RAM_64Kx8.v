// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module RAM_64Kx8(
    SRAM_A,
    SRAM_WE_X,
    SRAM_OE_X,

    SRAM_IO_A,
    SRAM_CE_A_X,
    SRAM_LB_A_X,
    SRAM_UB_A_X,

    SRAM_IO_B,
    SRAM_CE_B_X,
    SRAM_LB_B_X,
    SRAM_UB_B_X,

    i_addr,
    i_enable_x,
    i_write_x,
    i_data,
    o_data);
  output [17:0] SRAM_A;
  output        SRAM_WE_X;
  output        SRAM_OE_X;

  inout  [15:0] SRAM_IO_A;
  output        SRAM_CE_A_X;
  output        SRAM_LB_A_X;
  output        SRAM_UB_A_X;

  inout  [15:0] SRAM_IO_B;
  output        SRAM_CE_B_X;
  output        SRAM_LB_B_X;
  output        SRAM_UB_B_X;

  input  [15:0] i_addr;
  input         i_enable_x;
  input         i_write_x;
  input  [ 7:0] i_data;
  output [ 7:0] o_data;

  assign SRAM_A      = { 2'b00, i_addr };
  assign SRAM_WE_X   = i_enable_x | i_write_x;
  assign SRAM_OE_X   = i_enable_x | !i_write_x;

  assign SRAM_IO_A   = SRAM_WE_X ? 16'hzzzz : { 8'h00, i_data };
  assign SRAM_CE_A_X = i_enable_x;
  assign SRAM_LB_A_X = i_enable_x;
  assign SRAM_UB_A_X = 1'b1;

  assign SRAM_IO_B   = 16'hffff;
  assign SRAM_CE_B_X = 1'b1;
  assign SRAM_LB_B_X = 1'b1;
  assign SRAM_UB_B_X = 1'b1;

  assign o_data      = SRAM_WE_X ? SRAM_IO_A[7:0] : 8'h00;
endmodule  // module RAM_64Kx8
