// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the addr_check_n module. Applies various address, size, and mode combinations to
// verify address checking logic for different PMP modes (OFF, TOR, NA4, NAPOT). Instantiates the
// addr_check_n DUT and drives its inputs (addr, addr_n, addr_n_1, size, a_n) while observing the output.
//
// Dependencies:
// - addr_check_n.sv : Implements address checking logic for PMP modes.
// - cep_define      : Package containing PMP definitions.
//
// Author: Muhammad Furrukh
// Date:

import cep_define ::*;
module addr_check_n_tb();
  logic unsigned [31:0] addr, addr_n, addr_n_1;
  logic          [1:0]  size;
  logic          [1:0]  a_n;
  logic                 out;

  addr_check_n DUT(.*);

  initial begin
    // Testing for OFF mode
    addr_n = 32'h1234567E; addr_n_1 = 32'h1234566E; addr = 32'h1234566D; size = 2'b00; a_n = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234566E; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234567D; size = 2'b00;
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
    #10;

    // Testing for TOR mode
    addr = 32'h1234566D; size = 2'b00; a_n = 2'b01;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234566E; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234567D; size = 2'b00;
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
    #10;

    // Testing for NA4 mode
    addr = 32'h1234566D; size = 2'b00; a_n = 2'b10;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234566E; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h1234567D; size = 2'b00;
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
    #10;
    addr = 32'h1234567F; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h12345680; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h12345681; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = 32'h12345682; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;

    // Testing for NAPOT mode
    addr = (32'h1234566E & (~(32'b1))) - 1; size = 2'b00; a_n = 2'b11;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234566E & (~(32'b1))); size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567E & (~(32'b1))) - 1; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567E & (~(32'b1))); size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567E & (~(32'b1))) + 7; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    addr = (32'h1234567E & (~(32'b1))) + 8; size = 2'b00;
    #10;
    size = 2'b01;
    #10;
    size = 2'b11;
    #10;
    $stop;
  end
endmodule