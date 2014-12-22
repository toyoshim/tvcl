// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module ArbitorTest;
  wire [1:0] w_grant_2;
  wire [3:0] w_grant_4;

  reg  [3:0] r_request;
  reg        r_error;

  FixedPriorityArbitor arbitor_2(
      .i_request(r_request[1:0]),
      .o_grant  (w_grant_2     ));
  FixedPriorityArbitor #(.width(4)) arbitor_4(
      .i_request(r_request     ),
      .o_grant  (w_grant_4     ));

  always @ (posedge r_error) begin
    $display("unexpected grant %b for request %b", w_grant_4, r_request);
  end

  initial begin
    //$dumpfile("Arbitor.vcd");
    //$dumpvars(0, arbitor_4);
    r_error   <= 1'b0;
    r_request <= 4'b0000;
    #1
    r_error   <= w_grant_4 != 4'b0000;
    #1
    r_request <= 4'b0001;
    #1
    r_error   <= w_grant_4 != 4'b0001;
    #1
    r_request <= 4'b0010;
    #1
    r_error   <= w_grant_4 != 4'b0010;
    #1
    r_request <= 4'b0100;
    #1
    r_error   <= w_grant_4 != 4'b0100;
    #1
    r_request <= 4'b1000;
    #1
    r_error   <= w_grant_4 != 4'b1000;
    #1
    r_request <= 4'b0101;
    #1
    r_error   <= w_grant_4 != 4'b0001;
    #1
    r_request <= 4'b1110;
    #1
    r_error   <= w_grant_4 != 4'b0010;
    #1
    r_request <= 4'b1111;
    #1
    r_error   <= w_grant_4 != 4'b0001;
    #1
    $finish;
  end
endmodule  // ParityTest
