// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Top-level PMP (Physical Memory Protection) module that instantiates the PMP register
// file and PMP checking logic. Handles memory-mapped access to configuration and address
// registers and determines memory access permissions.
//
// Inputs:
// - clock           :                     Clock signal.
// - reset           :                     Asynchronous active-high reset.
// - wr_en           :                     Write enable signal.
// - size            : [1:0]               Size of the memory access (00: byte, 01: half-word, 10: word).
// - priv_mode       : [1:0]               Current processor privilege level
//                                         (00: M-mode, 01: S-mode, 10: U-mode) 
// - oper            : [1:0]               Operation to be performed on data in the accessed memory region
//                                         (00: Read, 01: Write, 10: Execute)          
// - addr            : [31:0] (unsigned)   Base address of the memory region to be accessed.
// - rw_addr         : [31:0] (unsigned)   Address of the CSR to read/write.
// - wdata           : [31:0]              Data to be written to the selected PMP CSR.
//
// Outputs:
// - rdata           : [31:0]              Data read from the addressed PMP CSR.
// - permission      : [1:0]               Permission granted or a specific type of fault 
//                                         (00: Read fault, 01: Write fault, 10: Execute fault, 11: Permission granted)
// Dependencies:
// - pmp_registers.v : Implements PMP configuration and address register storage.
// - pmp_check.v     : Contains access checking logic based on PMP configuration and memory access.
//
// Author: Muhammad Boota & Muhammad Furrukh
// Date:

module pmp (
    input  logic                 clock, reset, wr_en,
    input  logic          [1:0]  oper, size, priv_mode,
    input  logic unsigned [31:0] addr, rw_addr,
    input  logic          [31:0] wdata,
    output logic          [31:0] rdata,
    output logic          [1:0]  permission
);
    logic unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,  pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,   pmpaddr5_data,
                          pmpaddr6_data,  pmpaddr7_data,  pmpaddr8_data,  pmpaddr9_data,  pmpaddr10_data,  pmpaddr11_data,
                          pmpaddr12_data, pmpaddr13_data, pmpaddr14_data, pmpaddr15_data;
    logic          [31:0] pmpcfg0_data,   pmpcfg1_data,   pmpcfg2_data,   pmpcfg3_data;

    pmp_registers PMP_REG(.*);
    pmp_check     PMP_CHECK(.*);
endmodule