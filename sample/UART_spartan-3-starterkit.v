// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module UARTSpartan3StarterKit(
    // Clock Sources
    CLK50MHZ,
    SOCKET,
    // Fast, Asynchronous SRAM
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
    // Four-Digit, Saven-Segment LED Display
    LED_AN,
    LED_A,
    LED_B,
    LED_C,
    LED_D,
    LED_E,
    LED_F,
    LED_G,
    LED_DP,
    // Switch
    SW,
    // Button
    BTN,
    // LED
    LD,
    // VGA Port
    VGA_R,
    VGA_G,
    VGA_B,
    VGA_HS,
    VGA_VS,
    // PS2
    PS2C,
    PS2D,
    // RS-232 Serial Port
    RXD,
    TXD,
    RXDA,
    TXDA,
    // Platform Flash (XCF02S Serial PROM)
    DIN,
    INIT_B,
    RCLK);
  input         CLK50MHZ;
  input         SOCKET;

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

  output [ 3:0] LED_AN;
  output        LED_A;
  output        LED_B;
  output        LED_C;
  output        LED_D;
  output        LED_E;
  output        LED_F;
  output        LED_G;
  output        LED_DP;

  input  [ 7:0] SW;

  input  [ 3:0] BTN;

  output [ 7:0] LD;

  output        VGA_R;
  output        VGA_G;
  output        VGA_B;
  output        VGA_HS;
  output        VGA_VS;

  input         PS2C;
  input         PS2D;

  input         RXD;
  output        TXD;
  input         RXDA;
  output        TXDA;

  input         DIN;
  output        INIT_B;
  output        RCLK;

  wire          clk;
  wire          rst_x;
  wire          w_clk49khz;
  wire          w_tx_error;
  wire          w_rx_error;
  wire   [ 7:0] w_data;

  reg    [ 9:0] r_clock;
  reg           r_clk463khz;
  reg    [ 5:0] r_clk463khz_count;

  assign SRAM_A      = 18'h00000;
  assign SRAM_WE_X   = 1'b0;
  assign SRAM_OE_X   = 1'b1;
  assign SRAM_IO_A   = 16'hffff;
  assign SRAM_CE_A_X = 1'b1;
  assign SRAM_LB_A_X = 1'b1;
  assign SRAM_UB_A_X = 1'b1;
  assign SRAM_IO_B   = 16'hffff;
  assign SRAM_CE_B_X = 1'b1;
  assign SRAM_LB_B_X = 1'b1;
  assign SRAM_UB_B_X = 1'b1;

  assign LD          = SW | { 1'b0, BTN, PS2D, PS2C, SOCKET };

  assign VGA_R       = 1'b0;
  assign VGA_G       = 1'b0;
  assign VGA_B       = 1'b0;
  assign VGA_HS      = 1'b1;
  assign VGA_VS      = 1'b1;

  assign TXDA        = RXDA;

  assign INIT_B      = DIN;
  assign RCLK        = DIN;

  assign clk         = CLK50MHZ;
  assign rst_x       = !BTN[3];
  assign w_clk49khz  = r_clock[9];

  always @ (posedge clk or negedge rst_x) begin
    if (!rst_x) begin
      r_clock <= 10'h000;
    end else begin
      r_clock <= r_clock + 10'h001;
    end
  end

  always @ (posedge clk or negedge rst_x) begin
    if (!rst_x) begin
      r_clk463khz       <= 1'b0;
      r_clk463khz_count <= 6'h00;
    end else begin
      if (r_clk463khz_count != 6'h35) begin
        r_clk463khz_count <= r_clk463khz_count + 6'h01;
      end else begin
        r_clk463khz_count <= 6'h00;
        r_clk463khz       <= !r_clk463khz;
      end
    end
  end

  FourDigitSevenSegmentLED led(
      .clk       (w_clk49khz ),
      .rst_x     (rst_x      ),
      .i_data3   (4'b0000    ),
      .i_data2   (4'b0000    ),
      .i_data1   (w_data[7:4]),
      .i_data0   (w_data[3:0]),
      .i_dp3     (!w_tx_error),
      .i_dp2     (!w_rx_error),
      .i_dp1     (1'b1       ),
      .i_dp0     (1'b1       ),
      .o_a       (LED_A      ),
      .o_b       (LED_B      ),
      .o_c       (LED_C      ),
      .o_d       (LED_D      ),
      .o_e       (LED_E      ),
      .o_f       (LED_F      ),
      .o_g       (LED_G      ),
      .o_dp      (LED_DP     ),
      .o_select  (LED_AN     ));

  // 115200Hz UART
  UARTSample uart(
      .clk4x     (r_clk463khz),
      .rst_x     (rst_x      ),
      .i_rx      (RXD        ),
      .o_tx      (TXD        ),
      .o_data    (w_data     ),
      .o_tx_error(w_tx_error ),
      .o_rx_error(w_rx_error ));

endmodule  // UARTSpartan3StarterKit
