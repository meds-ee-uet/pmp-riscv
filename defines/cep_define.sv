// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
//   Common definitions, enumerations, and types for PMP CSRs and configuration.
//   Used throughout the PMP implementation.
//
// Dependencies:
// None.
//
// Author: Muhammad Boota
// Date: 

package cep_define;

typedef enum logic [11:0] {
    // PMP Configuration CSRs (4 entries per cfg)
    CSR_PMPCFG0   = 12'h3A0,
    CSR_PMPCFG1   = 12'h3A1,
    CSR_PMPCFG2   = 12'h3A2,
    CSR_PMPCFG3   = 12'h3A3,

    // PMP Address CSRs (1 per entry)
    CSR_PMPADDR0  = 12'h3B0,
    CSR_PMPADDR1  = 12'h3B1,
    CSR_PMPADDR2  = 12'h3B2,
    CSR_PMPADDR3  = 12'h3B3,
    CSR_PMPADDR4  = 12'h3B4,
    CSR_PMPADDR5  = 12'h3B5,
    CSR_PMPADDR6  = 12'h3B6,
    CSR_PMPADDR7  = 12'h3B7,
    CSR_PMPADDR8  = 12'h3B8,
    CSR_PMPADDR9  = 12'h3B9,
    CSR_PMPADDR10 = 12'h3BA,
    CSR_PMPADDR11 = 12'h3BB,
    CSR_PMPADDR12 = 12'h3BC,
    CSR_PMPADDR13 = 12'h3BD,
    CSR_PMPADDR14 = 12'h3BE,
    CSR_PMPADDR15 = 12'h3BF
} pmp_csr_e;

typedef enum logic[1:0] { 
    OFF,
    TOR,
    NA4,
    NAPOT
 } mode;

typedef struct packed {
    logic        L;      // Lock bit (bit 7)
    logic [1:0]  reserved; // Reserved bits (bits 6:5)
    mode         A;      // Address matching mode (bits 4:3)
    logic        X;      // Execute permission (bit 2)
    logic        W;      // Write permission (bit 1)
    logic        R;      // Read permission (bit 0)
} pmpcfg;

typedef enum logic[1:0] { 
   READ,
   WRITE,
   EXECUTE,
   NOTHING
} operations;
endpackage
