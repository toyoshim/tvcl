// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module LED2Spartan3StarterKit(
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
  wire   [ 3:0] w_data0;
  wire   [ 3:0] w_data1;
  wire   [ 3:0] w_data2;
  wire   [ 3:0] w_data3;
  wire          w_dp0;
  wire          w_dp1;
  wire          w_dp2;
  wire          w_dp3;
  wire          w_clk3hz;
  wire          w_clk49khz;

  reg    [24:0] r_clock;
  reg    [ 3:0] r_count;

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

  assign TXD         = RXD;
  assign TXDA        = RXDA;

  assign INIT_B      = DIN;
  assign RCLK        = DIN;

  assign clk         = CLK50MHZ;
  assign rst_x       = !BTN[3];
  assign w_data0     = r_count;
  assign w_data1     = r_count + 4'h1;
  assign w_data2     = r_count + 4'h2;
  assign w_data3     = r_count + 4'h3;
  assign w_dp0       = r_count[1:0] != 2'b00;
  assign w_dp1       = r_count[1:0] != 2'b01;
  assign w_dp2       = r_count[1:0] != 2'b10;
  assign w_dp3       = r_count[1:0] != 2'b11;
  assign w_clk3hz    = r_clock[24];
  assign w_clk49khz  = r_clock[9];

  always @ (posedge clk or negedge rst_x) begin
    if (!rst_x) begin
      r_clock <= 25'h0000000;
    end else begin
      r_clock <= r_clock + 25'h0000001;
    end
  end

  always @ (posedge w_clk3hz or negedge rst_x) begin
    if (!rst_x) begin
      r_count <= 4'h0;
    end else begin
      r_count <= r_count + 4'h1;
    end
  end

  FourDigitSevenSegmentLED led(
      .clk     (w_clk49khz),
      .rst_x   (rst_x     ),
      .i_data3 (w_data3   ),
      .i_data2 (w_data2   ),
      .i_data1 (w_data1   ),
      .i_data0 (w_data0   ),
      .i_dp3   (w_dp3     ),
      .i_dp2   (w_dp2     ),
      .i_dp1   (w_dp1     ),
      .i_dp0   (w_dp0     ),
      .o_a     (LED_A     ),
      .o_b     (LED_B     ),
      .o_c     (LED_C     ),
      .o_d     (LED_D     ),
      .o_e     (LED_E     ),
      .o_f     (LED_F     ),
      .o_g     (LED_G     ),
      .o_dp    (LED_DP    ),
      .o_select(LED_AN    ));

endmodule  // LED2Spartan3StarterKit
