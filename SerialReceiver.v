// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module SerialReceiver(
    clk_x4,
    rst_x,
    i_rx,
    o_data,
    o_valid,
    o_error);
  input        clk_x4;
  input        rst_x;
  input        i_rx;

  output [7:0] o_data;
  output       o_valid;
  output       o_error;

  reg    [1:0] r_phase;
  reg    [3:0] r_state;
  reg    [7:0] r_data;

  wire         w_phase_latch;
  wire         w_phase_shift;
  wire         w_phase_next;
  wire         w_valid;
  wire         w_stop;

  localparam S_IDLE  = 4'b0000;
  localparam S_START = 4'b0001;
  localparam S_BIT0  = 4'b0011;
  localparam S_BIT1  = 4'b0010;
  localparam S_BIT2  = 4'b0110;
  localparam S_BIT3  = 4'b0111;
  localparam S_BIT4  = 4'b0101;
  localparam S_BIT5  = 4'b0100;
  localparam S_BIT6  = 4'b1100;
  localparam S_BIT7  = 4'b1101;
  localparam S_STOP  = 4'b1111;

  assign w_phase_latch = r_phase == 2'b01;
  assign w_phase_next  = r_phase == 2'b10;
  assign w_phase_shift = r_phase == 2'b11;
  assign w_valid       = (r_state == S_STOP) && w_phase_latch;
  assign w_stop        = i_rx == 1'b1;

  assign o_data        = r_data;
  assign o_valid       = w_valid & w_stop;
  assign o_error       = w_valid & !w_stop;

  always @ (posedge clk_x4) begin
    if (w_phase_latch) begin
      r_data <= { i_rx, r_data[7:1] };
    end
  end  // always @ (posedge clk_x4)

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_phase <= 2'b00;
    end else begin
      if (r_state == S_IDLE) begin
        r_phase <= 2'b00;
      end else begin
        r_phase <= r_phase + 2'b01;
      end
    end  // else (!rst_x)
  end  // always @ (posedge clk_x4 or negedge rst_x)

  always @ (posedge clk_x4 or negedge rst_x) begin
    if (!rst_x) begin
      r_state <= S_IDLE;
    end else begin
      case (r_state)
        S_IDLE: begin
          if (i_rx == 1'b0) begin
            r_state <= S_START;
          end
        end  // S_IDLE
        S_START: begin
          if (w_phase_shift) begin
            r_state <= S_BIT0;
          end
        end  // S_START
        S_BIT0: begin
          if (w_phase_shift) begin
            r_state <= S_BIT1;
          end
        end  // S_BIT0
        S_BIT1: begin
          if (w_phase_shift) begin
            r_state <= S_BIT2;
          end
        end  // S_BIT1
        S_BIT2: begin
          if (w_phase_shift) begin
            r_state <= S_BIT3;
          end
        end  // S_BIT2
        S_BIT3: begin
          if (w_phase_shift) begin
            r_state <= S_BIT4;
          end
        end  // S_BIT3
        S_BIT4: begin
          if (w_phase_shift) begin
            r_state <= S_BIT5;
          end
        end  // S_BIT4
        S_BIT5: begin
          if (w_phase_shift) begin
            r_state <= S_BIT6;
          end
        end  // S_BIT5
        S_BIT6: begin
          if (w_phase_shift) begin
            r_state <= S_BIT7;
          end
        end  // S_BIT6
        S_BIT7: begin
          if (w_phase_shift) begin
            r_state <= S_STOP;
          end
        end  // S_BIT7
        S_STOP: begin
          if (w_phase_next) begin
            r_state <= S_IDLE;
          end
        end  // S_STOP
      endcase // case (r_state)
    end  // else (!rst_x)
  end  // always @ (posedge clk_x4 or negedge rst_x)
endmodule  // SerialReceiver
