// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module RAMSpartan3StarterKit(
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
  wire   [ 7:0] w_data;

  reg    [ 9:0] r_clock;
  reg    [15:0] r_addr;
  reg           r_enable_x;
  reg           r_write_x;
  reg           r_ram_init;
  reg           r_read;
  reg           r_read_d;
  reg    [ 7:0] r_read_data;

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
      r_addr      <= 16'h0000;
      r_enable_x  <= 1'b0;
      r_write_x   <= 1'b0;
      r_ram_init  <= 1'b1;
      r_read      <= 1'b0;
      r_read_d    <= 1'b0;
      r_read_data <= 8'h00;
    end else begin
      if (r_ram_init) begin
        if (r_addr == 16'hffff) begin
          r_ram_init  <= 1'b0;
          r_write_x   <= 1'b1;
        end else begin
          r_addr      <= r_addr + 16'h0001;
        end
      end else begin
        if (!r_read & BTN[0]) begin
          r_addr      <= { SW, SW };
        end
        if (!r_read_d & r_read) begin
          r_read_data <= w_data;
        end
        r_read      <= BTN[0];
        r_read_d    <= r_read;
      end  // else (r_ram_init)
    end
  end

  RAM_64Kx8 ram(
      .SRAM_A     (SRAM_A          ),
      .SRAM_WE_X  (SRAM_WE_X       ),
      .SRAM_OE_X  (SRAM_OE_X       ),
      .SRAM_IO_A  (SRAM_IO_A       ),
      .SRAM_CE_A_X(SRAM_CE_A_X     ),
      .SRAM_LB_A_X(SRAM_LB_A_X     ),
      .SRAM_UB_A_X(SRAM_UB_A_X     ),
      .SRAM_IO_B  (SRAM_IO_B       ),
      .SRAM_CE_B_X(SRAM_CE_B_X     ),
      .SRAM_LB_B_X(SRAM_LB_B_X     ),
      .SRAM_UB_B_X(SRAM_UB_B_X     ),
      .i_addr     (r_addr          ),
      .i_enable_x (r_enable_x      ),
      .i_write_x  (r_write_x       ),
      .i_data     (r_addr[7:0]     ),
      .o_data     (w_data          ));

  FourDigitSevenSegmentLED led(
      .clk        (w_clk49khz      ),
      .rst_x      (rst_x           ),
      .i_data3    (4'h0            ),
      .i_data2    (4'h0            ),
      .i_data1    (r_read_data[7:4]),
      .i_data0    (r_read_data[3:0]),
      .i_dp3      (1'b1            ),
      .i_dp2      (1'b1            ),
      .i_dp1      (1'b1            ),
      .i_dp0      (r_ram_init      ),
      .o_a        (LED_A           ),
      .o_b        (LED_B           ),
      .o_c        (LED_C           ),
      .o_d        (LED_D           ),
      .o_e        (LED_E           ),
      .o_f        (LED_F           ),
      .o_g        (LED_G           ),
      .o_dp       (LED_DP          ),
      .o_select   (LED_AN          ));

endmodule  // RAMSpartan3StarterKit
