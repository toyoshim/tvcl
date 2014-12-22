// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 1ns/100ps

module RAMTest;
  reg         clk;

  wire  [7:0] w_out_data;
  wire  [7:0] w_in_data;
  reg         r_enable_x;
  reg         r_write_x;
  reg  [15:0] r_addr;
  reg  [ 7:0] r_data;
  integer     i;

  RAM_64Kx8 dut(
      .i_addr    (r_addr    ),
      .i_enable_x(r_enable_x),
      .i_write_x (r_write_x ),
      .i_data    (w_in_data ),
      .o_data    (w_out_data));

  // 20ns (50MHz)
  always #10 clk = !clk;

  assign w_in_data = r_data;

  always @ (posedge clk) begin
    if (!r_enable_x & r_write_x) begin
      $display("read $%04x => $%02x", r_addr, w_out_data);
    end
  end

  //initial $readmemh("RAM.hex", dut.ram.r_ram);

  initial begin
    //$dumpfile("RAM.vcd");
    //$dumpvars(0, clk);
    //$dumpvars(0, dut);
    clk        <= 1'b1;
    r_enable_x <= 1'b1;
    r_write_x  <= 1'b1;
    r_addr     <= 16'h0000;
    r_data     <= 8'h00;
    #1
    r_enable_x <= 1'b0;
    #20
    r_addr     <= 16'h0001;
    for (i = 0; i < 'h10000; i = i + 1) begin
      #20
      r_addr     <= i;
      r_data     <= i[7:0];
      r_write_x  <= 1'b0;
    end
    for (i = 0; i < 'h10000; i = i + 1) begin
      #20
      r_addr     <= i;
      r_write_x  <= 1'b1;
    end
    #20
    $finish;
  end
endmodule  // RAMTest
