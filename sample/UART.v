// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module UARTSample(
    clk_x4,
    rst_x,

    i_rx,
    o_tx,

    o_data,
    o_tx_error,
    o_rx_error);
  input        clk_x4;
  input        rst_x;

  input        i_rx;
  output       o_tx;

  output [7:0] o_data;
  output       o_tx_error;
  output       o_rx_error;

  wire   [7:0] w_out;
  wire         w_out_valid;
  wire         w_tx_error;
  wire         w_rx_error;
  wire         w_busy;
  wire         w_busy_posedge;

  reg    [7:0] r_in;
  reg          r_in_valid;
  reg          r_tx_error;
  reg          r_rx_error;
  reg    [7:0] r_data;
  reg    [2:0] r_state;
  reg          r_busy_d;

  localparam S_TX_WAIT = 3'b000;
  localparam S_TX_H    = 3'b001;
  localparam S_TX_E    = 3'b011;
  localparam S_TX_L    = 3'b010;
  localparam S_TX_O    = 3'b110;

  localparam C_H       = 8'h48;
  localparam C_E       = 8'h45;
  localparam C_L       = 8'h4c;
  localparam C_O       = 8'h4f;

  assign o_tx_error     = r_tx_error;
  assign o_rx_error     = r_rx_error;
  assign o_data         = r_data;

  assign w_in           = 8'h00;
  assign w_in_valid     = 1'b0;
  assign w_busy_posedge = !r_busy_d & w_busy;
  assign w_busy_negedge = r_busy_d & !w_busy;

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_tx_error <= 1'b0;
    end else begin
      r_tx_error <= r_tx_error | w_tx_error;
    end
  end

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_rx_error <= 1'b0;
    end else begin
      r_rx_error <= r_rx_error | w_rx_error;
    end
  end

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_data <= 8'h00;
    end else begin
      if (w_out_valid) begin
        r_data <= w_out;
      end
    end
  end

  always @ (posedge clk_x4) begin
    r_busy_d <= w_busy;
  end

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_state    <= S_TX_WAIT;
      r_in       <= 8'h00;
      r_in_valid <= 1'b0;
    end else begin
      case (r_state)
        S_TX_WAIT: begin
          if ((w_out == 8'h0d) && w_out_valid) begin
            r_state    <= S_TX_H;
            r_in       <= C_H;
            r_in_valid <= 1'b1;
          end
        end
        S_TX_H: begin
          if (w_busy_posedge) begin
            r_in_valid <= 1'b0;
          end else if (w_busy_negedge) begin
            r_state    <= S_TX_E;
            r_in       <= C_E;
            r_in_valid <= 1'b1;
          end
        end
        S_TX_E: begin
          if (w_busy_posedge) begin
            r_in_valid <= 1'b0;
          end else if (w_busy_negedge) begin
            r_state    <= S_TX_L;
            r_in       <= C_L;
            r_in_valid <= 1'b1;
          end
        end
        S_TX_L: begin
          if (w_busy_posedge) begin
            r_in_valid <= 1'b0;
          end else if (w_busy_negedge) begin
            r_state    <= S_TX_O;
            r_in       <= C_O;
            r_in_valid <= 1'b1;
          end
        end
        S_TX_O: begin
          if (w_busy_posedge) begin
            r_in_valid <= 1'b0;
          end else if (w_busy_negedge) begin
            r_state    <= S_TX_WAIT;
            r_in       <= 8'h00;
          end
        end
      endcase
    end
  end

  UART uart(
      .clk_x4    (clk_x4     ),
      .rst_x     (rst_x      ),
      .i_rx      (i_rx       ),
      .o_tx      (o_tx       ),
      .i_data    (r_in       ),
      .i_valid   (r_in_valid ),
      .o_busy    (w_busy     ),
      .o_data    (w_out      ),
      .o_valid   (w_out_valid),
      .o_tx_error(w_tx_error ),
      .o_rx_error(w_rx_error ));
endmodule  // UARTSample
