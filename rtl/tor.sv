// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// This module implements address matching for TOR mode.
//
// Inputs:
// - addr       : [31:0] (unsigned) Base address of the memory region to be accessed.
// - addr_n     : [31:0] (unsigned) Value of the nth PMP address register.
// - addr_n_1   : [31:0] (unsigned) Value of the (n-1)th PMP address register.
// - size       : [1:0]             Size of the memory access (00: byte, 01: half-word, 10: word).
//
// Output:
// - tor_out    : [0:0]             High if the memory region is supposedly protected by the Nth PMP entry; low otherwise.
//
// Dependencies:
// There are no dependancies.
//
// Author: Muhammad Boota & Muhammad Furrukh
// Date:

module tor (
    input  logic unsigned [31:0] addr, addr_n_1, addr_n,
    input  logic          [1:0]  size,
    output logic                 tor_out
);

always_comb begin
    tor_out = ( (addr <= (addr + size)) && (addr >= addr_n_1) && ((addr + size) < (addr_n)) );
end
endmodule