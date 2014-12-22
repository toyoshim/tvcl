// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module LEDSample(
    clk,
    rst_x,

    o_a,
    o_b,
    o_c,
    o_d,
    o_e,
    o_f,
    o_g,
    o_dp);
  input        clk;
  input        rst_x;

  output       o_a;
  output       o_b;
  output       o_c;
  output       o_d;
  output       o_e;
  output       o_f;
  output       o_g;
  output       o_dp;

  reg    [4:0] r_count;

  assign o_dp     = r_count[0] & rst_x;

  always @ (posedge clk or negedge rst_x) begin
    if (!rst_x) begin
      r_count <= 5'h00;
    end else begin
      r_count <= r_count + 5'h01;
    end
  end  // always

  SevenSegmentLED led(
      .i_data(r_count[4:1]),
      .o_a    (o_a        ),
      .o_b    (o_b        ),
      .o_c    (o_c        ),
      .o_d    (o_d        ),
      .o_e    (o_e        ),
      .o_f    (o_f        ),
      .o_g    (o_g        ));
endmodule  // LEDSample
