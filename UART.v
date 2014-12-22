// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module UART(
    clk_x4,
    rst_x,
    // UART interfaces
    i_rx,
    o_tx,
    // Control interfaces
    i_data,
    i_valid,
    o_busy,
    o_data,
    o_valid,
    // Error interfaces
    o_tx_error,
    o_rx_error);
  input        clk_x4;
  input        rst_x;

  input        i_rx;
  output       o_tx;

  input  [7:0] i_data;
  input        i_valid;
  output       o_busy;
  output [7:0] o_data;
  output       o_valid;

  output       o_tx_error;
  output       o_rx_error;

  SerialTransmitter tx(
      .clk_x4 (clk_x4    ),
      .rst_x  (rst_x     ),
      .i_data (i_data    ),
      .i_valid(i_valid   ),
      .o_tx   (o_tx      ),
      .o_busy (o_busy    ),
      .o_error(o_tx_error));

  SerialReceiver rx(
      .clk_x4 (clk_x4    ),
      .rst_x  (rst_x     ),
      .i_rx   (i_rx      ),
      .o_data (o_data    ),
      .o_valid(o_valid   ),
      .o_error(o_rx_error));

endmodule  // SerialTransmitter
