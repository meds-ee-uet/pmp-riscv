// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// This module implements address matching for NA4 mode.
//
// Inputs:
// - addr       : [31:0] (unsigned) Base address of the memory region to be accessed.
// - addr_n     : [31:0] (unsigned) Value of the nth PMP address register.
// - size       : [1:0]             Size of the memory access (00: byte, 01: half-word, 11: word).
//
// Output:
// - na4_out    : [0:0]             High if the memory region is supposedly protected by the Nth PMP entry; low otherwise.
//
// Dependencies:
// There are no dependancies.
//
// Author: Muhammad Boota, Muhammad Furrukh
// Date: 

module na4 (
    input  logic unsigned [31:0] addr, addr_n,
    input  logic          [1:0]  size,
    output logic                 na4_out
);

always_comb begin
    na4_out = (addr >= (addr_n))  && ((addr + size) <= (addr_n + 3));
end
endmodule