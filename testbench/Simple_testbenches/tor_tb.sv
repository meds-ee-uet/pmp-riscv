// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the tor module. Applies various address and size combinations to verify
// TOR address matching logic for different region boundaries.
//
// Dependencies:
// - tor.sv : Implements TOR address matching logic.
//
// Author: Umair Ahmad
// Date:

module tor_tb();
  logic unsigned [31:0] addr, addr_n_1, addr_n;
  logic          [1:0]  size;
  logic                 tor_out;

  tor DUT(.*);

  initial begin
    // Example region: [addr_n_1, addr_n)
    addr_n_1 = 32'h00001000; addr_n = 32'h00002000;

    // Test addresses below, at, and above region with all sizes
    int i;
    for (i = 0; i < 4; i++) begin
      size = i[1:0];
      addr = addr_n_1 - 1; #10;
      addr = addr_n_1;     #10;
      addr = addr_n_1 + 1; #10;
      addr = addr_n - 1;   #10;
      addr = addr_n;       #10;
      addr = addr_n + 1;   #10;
    end

    // Test another region
    addr_n_1 = 32'h00003000; addr_n = 32'h00004000;
    for (i = 0; i < 4; i++) begin
      size = i[1:0];
      addr = addr_n_1; #10;
      addr = addr_n_1 + 100; #10;
      addr = addr_n - 1; #10;
      addr = addr_n; #10;
    end

    // Edge cases
    addr_n_1 = 32'h0; addr_n = 32'h100;
    for (i = 0; i < 4; i++) begin
      size = i[1:0];
      addr = 32'h0; #10;
      addr = 32'hFF; #10;
      addr = 32'h100; #10;
    end

    $stop;
  end
endmodule