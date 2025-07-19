// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// This module determines whether a given memory address falls within the protection range 
// of the nth Physical Memory Protection (PMP) entry, as specified in the RISC-V PMP specification.
//
// Inputs:
// - addr       : [31:0] (unsigned) Base address of the memory region to be accessed.
// - addr_n     : [31:0] (unsigned) Value of the nth PMP address register.
// - addr_n_1   : [31:0] (unsigned) Value of the (n-1)th PMP address register (Used in TOR mode).
// - size       : [1:0]             Size of the memory access (00: byte, 01: half-word, 10: word).
// - a_n        : [1:0]             Address matching mode for the nth PMP entry 
//                                  (00: OFF, 01: TOR, 10: NA4, 11: NAPOT).
//
// Output:
// - out        : [0:0]             High if the memory region is protected by the Nth PMP entry; low otherwise.
//
// Dependencies:
// - `cep_define.sv` : Package file
// - na4.sv          : Implements address matching for NA4 mode.
// - napot.sv        : Implements address matching for NAPOT mode.
// - tor.sv          : Implements address matching for TOR mode.
//
// Author: Muhammad Boota, Muhammad Furrukh
// Date: 

import cep_define ::*;
module addr_check_n (
    input  logic unsigned [31:0] addr, addr_n, addr_n_1,
    input  logic          [1:0]  size,
    input  logic          [1:0]  a_n,
    output logic                 out
);

logic na4_out, napot_out, tor_out;

tor     TOR(.*);
na4     NA4(.*);
napot   NAPOT(.*);

always_comb begin
    case (a_n)
       2'b00:   out = 1'b0;
       2'b01:   out = tor_out;
       2'b10:   out = na4_out;
       2'b11:   out = napot_out;
       default: out = 1'b0;
    endcase
end
endmodule