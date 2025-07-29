// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the na4 module. Applies various address and size combinations to verify
// NA4 address matching logic for different edge and boundary cases.
//
// Dependencies:
// - na4.sv : Implements NA4 address matching logic.
//
// Author: Salman Aslam
// Date:

module tb_na4();
    logic unsigned [31:0] addr, addr_n;
    logic [1:0] size;
    logic na4_out;

    na4 uut (
        .addr(addr),
        .addr_n(addr_n),
        .size(size),
        .na4_out(na4_out)
    );

    initial begin
        // Test 1: Overflow case (addr + size < addr)
        addr = 32'hFFFFFFFF;
        addr_n = 32'h00000000;
        size = 2'b10; // 3
        #10;
        if (na4_out !== 1'b0) $error("Test 1: Overflow failed");

        // Test 2: addr == addr_n, size = 0 (valid)
        addr = 100;
        addr_n = 100;
        size = 2'b00;
        #10;
        if (na4_out !== 1'b1) $error("Test 2: Exact match failed");

        // Test 3: addr exceeds addr_n+3 (invalid)
        addr = 103;
        addr_n = 100;
        size = 2'b01; // 1
        #10;
        if (na4_out !== 1'b0) $error("Test 3: Exceeds range failed");

        // Test 4: addr < addr_n (invalid)
        addr = 99;
        addr_n = 100;
        size = 2'b00;
        #10;
        if (na4_out !== 1'b0) $error("Test 4: Below addr_n failed");

        // Test 5: addr + size == addr_n + 3 (valid)
        addr = 50;
        addr_n = 50;
        size = 2'b11; // 3
        #10;
        if (na4_out !== 1'b1) $error("Test 5: Full range failed");

        // Test 6: Boundary check (addr + size exactly fits)
        addr = 101;
        addr_n = 100;
        size = 2'b10; // 2
        #10;
        if (na4_out !== 1'b1) $error("Test 6: Boundary fit failed");

        $display("All tests passed!");
        $stop;
    end
endmodule