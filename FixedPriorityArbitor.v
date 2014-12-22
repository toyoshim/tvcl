// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module FixedPriorityArbitor(
    i_request,
    o_grant);
  parameter width = 2;

  input  [width - 1:0] i_request;
  output [width - 1:0] o_grant;

  wire   [width - 1:0] w_forward;

  assign w_forward = { w_forward[width - 2:0] & ~i_request[width - 2:0], 1'b1 };
  assign o_grant   = w_forward & i_request;
endmodule  // EvenParityGenerator
