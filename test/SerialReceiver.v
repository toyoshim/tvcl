// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module SerialReceiverTest;
  reg        clk;
  reg        rst_x;
  reg        rx;

  wire [7:0] w_data;
  wire       w_valid;
  wire       w_error;

  always #4 clk = ~clk;

  always @ (posedge w_valid) begin
    $display("receive: $%02x", w_data);
  end

  always @ (posedge w_error) begin
    $display("receive: can not detect stop bit");
  end

  SerialReceiver dut(
      .clk_x4 (clk    ),
      .rst_x  (rst_x  ),
      .i_rx   (rx     ),
      .o_data (w_data ),
      .o_valid(w_valid),
      .o_error(w_error));

  initial begin
    //$dumpfile("SerialReceiver.vcd");
    //$dumpvars(0, dut);
    clk   <= 1'b0;
    rst_x <= 1'b1;
    rx    <= 1'b1;
    #8
    rst_x <= 1'b0;
    #32
    rst_x <= 1'b1;
    #32
    // Receive two bytes without any gap between stop bit and start bit.
    rx    <= 1'b0;  // start bit
    #32
    rx    <= 1'b1;  // bit 0
    #32
    rx    <= 1'b0;  // bit 1
    #32
    rx    <= 1'b1;  // bit 2
    #32
    rx    <= 1'b1;  // bit 3
    #32
    rx    <= 1'b0;  // bit 4
    #32
    rx    <= 1'b0;  // bit 5
    #32
    rx    <= 1'b1;  // bit 6
    #32
    rx    <= 1'b0;  // bit 7
    #32
    rx    <= 1'b1;  // stop bit : 0b01001101 = 0x4d
    #32
    rx    <= 1'b0;  // start bit
    #32
    rx    <= 1'b0;  // bit 0
    #32
    rx    <= 1'b1;  // bit 1
    #32
    rx    <= 1'b0;  // bit 2
    #32
    rx    <= 1'b1;  // bit 3
    #32
    rx    <= 1'b0;  // bit 4
    #32
    rx    <= 1'b1;  // bit 5
    #32
    rx    <= 1'b0;  // bit 6
    #32
    rx    <= 1'b1;  // bit 7
    #32
    rx    <= 1'b1;  // stop bit : 0b10101010 = 0xaa
    #32
    // Receive invalid data that does not has stop bit.
    rx    <= 1'b0;  // start bit
    #32
    rx    <= 1'b1;  // bit 0
    #32
    rx    <= 1'b1;  // bit 1
    #32
    rx    <= 1'b1;  // bit 2
    #32
    rx    <= 1'b1;  // bit 3
    #32
    rx    <= 1'b1;  // bit 4
    #32
    rx    <= 1'b1;  // bit 5
    #32
    rx    <= 1'b1;  // bit 6
    #32
    rx    <= 1'b1;  // bit 7
    #32
    rx    <= 1'b0;  // invalid stop bit
    #32
    rx    <= 1'b1;
    #31
    // Receive a data in unstable timing.
    rx    <= 1'b0;  // start bit
    #32
    rx    <= 1'b1;  // bit 0
    #33
    rx    <= 1'b0;  // bit 1
    #31
    rx    <= 1'b1;  // bit 2
    #32
    rx    <= 1'b0;  // bit 3
    #33
    rx    <= 1'b1;  // bit 4
    #31
    rx    <= 1'b0;  // bit 5
    #32
    rx    <= 1'b1;  // bit 6
    #33
    rx    <= 1'b0;  // bit 7
    #31
    rx    <= 1'b1;  // stop bit : 0b01010101 = 0x55
    #40
    // Receive a data in hazardous timing.
    rx    <= 1'b0;  // start bit
    #32
    rx    <= 1'b1;  // bit 0
    #33
    rx    <= 1'b0;  // bit 1
    #31
    rx    <= 1'b1;  // bit 2
    #32
    rx    <= 1'b0;  // bit 3
    #33
    rx    <= 1'b1;  // bit 4
    #31
    rx    <= 1'b0;  // bit 5
    #32
    rx    <= 1'b1;  // bit 6
    #33
    rx    <= 1'b0;  // bit 7
    #32
    rx    <= 1'b1;  // stop bit : 0b01010101 = 0x55
    #32
    $finish;
  end
endmodule  // SerialReceiverTest
