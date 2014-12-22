// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module SerialTransmitterTest;
  reg        clk;
  reg        rst_x;

  reg  [7:0] r_data;
  reg        r_valid;

  wire       w_error;
  wire       w_busy;

  wire       w_tx2rx;

  wire [7:0] w_data;
  wire       w_valid;
  wire       w_nostop;

  always #4 clk = ~clk;

  always @ (posedge w_valid) begin
    $display("receive: $%02x", w_data);
  end

  always @ (posedge w_nostop) begin
    $display("receive: can not detect stop bit");
  end

  always @ (posedge w_error) begin
    $display("transmit: unexpected request on a busy cycle");
  end

  SerialTransmitter dut(
      .clk_x4 (clk     ),
      .rst_x  (rst_x   ),
      .i_data (r_data  ),
      .i_valid(r_valid ),
      .o_tx   (w_tx2rx ),
      .o_busy (w_busy  ),
      .o_error(w_error ));

  SerialReceiver rx(
      .clk_x4 (clk     ),
      .rst_x  (rst_x   ),
      .i_rx   (w_tx2rx ),
      .o_data (w_data  ),
      .o_valid(w_valid ),
      .o_error(w_nostop));

  initial begin
    $dumpfile("SerialTransmitter.vcd");
    $dumpvars(0, dut);
    clk     <= 1'b0;
    rst_x   <= 1'b1;
    r_valid <= 1'b0;
    #32
    rst_x   <= 1'b0;
    #32
    rst_x   <= 1'b1;
    #20
    // Transmit a data.
    r_data  <= 8'hde;
    r_valid <= 1'b1;
    #8
    r_valid <= 1'b0;
    #312
    // Transmit another data immediately.
    r_data  <= 8'had;
    r_valid <= 1'b1;
    #8
    r_valid <= 1'b0;
    #308
    // Error due to request on busy cycle.
    r_valid <= 1'b1;
    #4

    $finish;
  end
endmodule  // SerialTransmitterTest
