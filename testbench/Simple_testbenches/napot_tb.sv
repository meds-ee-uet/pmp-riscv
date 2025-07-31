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
    int i;
    // Testing effect of addr and size for given addr_n on the output
    addr_n = 32'h1234567E; addr = 32'h1234567E - 32'h1; 
    for (i = 0; i < 10; i++) begin
      size = 2'b00;
      #10;
      size = 2'b01;
      #10;
      size = 2'b11;
      #10;
      addr += 32'h1;
    end

    #10;

    // Testing different addr_n
    // Case 1
    addr_n = 32'h1234567D; addr = (32'h1234567D & (~(32'b1))) - 32'h1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567D & (~(32'b1)));
    #10;
    addr = (32'h1234567D & (~(32'b1))) + 32'hF; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 2
    addr_n = 32'h1234567B; addr = (32'h1234567B & (~(32'b11))) - 32'h1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567B & (~(32'b11)));
    #10;
    addr = (32'h1234567B & (~(32'b11))) + 32'h1F; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 3
    addr_n = 32'h12345677; addr = (32'h12345677 & (~(32'b111))) - 32'h1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h12345677 & (~(32'b111)));
    #10;
    addr = (32'h12345677 & (~(32'b111))) + 32'h3F; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 4
    addr_n = 32'h1234566F; addr = (32'h1234566F & (~(32'b1111))) - 32'h1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234566F & (~(32'b1111)));
    #10;
    addr = (32'h1234566F & (~(32'b1111))) + 32'h7F; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Edge cases
    // Case 1
    addr_n = 32'h0; addr = 32'h0 - 32'h1; size = 2'b00; 
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h0;
    #10;
    addr = 32'h0 + 32'h7; size = 2'h00;
    #10;
    size = 2'b01;
    #10;

    // Case 2
    addr_n = 32'hFFFFFFFF; addr = 32'h0; size = 2'b11;
    #10;
    addr = 32'hFFFFFFFF - 32'h7; 
    #10;
    addr = 32'hFFFFFFFF; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;

    $stop;
  end
endmodule