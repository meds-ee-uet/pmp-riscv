// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the napot module. Applies various address and size combinations to verify
// NAPOT address matching logic for different addr_n values. Instantiates the napot DUT and
// drives its inputs (addr, addr_n, size) while observing the output (napot_out).
//
// Dependencies:
// - napot.sv : Implements NAPOT address matching logic.
//
// Author: Muhammad Furrukh
// Date:

module napot_tb();
  logic unsigned [31:0] addr, addr_n;
  logic          [1:0]  size;
  logic                 napot_out;

  napot DUT(.*);

  initial begin
    // Testing effect of addr and size for given addr_n on the output
    addr_n = 32'h1234567E; addr = 32'h1234567E - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234567E; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    addr = 32'h1234567E + 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    addr = 32'h1234567E + 2; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    addr = 32'h1234567E + 3; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    addr = 32'h1234567E + 4; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    addr = 32'h1234567E + 5; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;

    // Testing different addr_n
    // Case 1
    addr_n = 32'h1234567D; addr = (32'h1234567D & (~(32'b1))) - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567D & (~(32'b1)));
    #10;
    addr = (32'h1234567D & (~(32'b1))) + 15; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 2
    addr_n = 32'h1234567B; addr = (32'h1234567B & (~(32'b11))) - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567B & (~(32'b11)));
    #10;
    addr = (32'h1234567B & (~(32'b11))) + 31; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 3
    addr_n = 32'h12345677; addr = (32'h12345677 & (~(32'b111))) - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h12345677 & (~(32'b111)));
    #10;
    addr = (32'h12345677 & (~(32'b111))) + 63; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 4
    addr_n = 32'h1234566F; addr = (32'h1234566F & (~(32'b1111))) - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234566F & (~(32'b1111)));
    #10;
    addr = (32'h1234566F & (~(32'b1111))) + 127; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Edge cases
    // Case 4
    addr_n = 32'h0; addr = 32'h0 - 1; size = 2'b00; 
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h0;
    #10;
    addr = 32'h0 + 7; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 5
    addr_n = 32'hFFFFFFFF; addr = 32'h0; size = 2'b11;
    #10;
    addr = 32'hFFFFFFFF - 7; 
    #10;
    addr = 32'hFFFFFFFF; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;

    $stop;
  end
endmodule