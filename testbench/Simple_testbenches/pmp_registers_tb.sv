// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the pmp_registers module. Stimulates the PMP register file by performing write and read
// operations on configuration and address registers under different privilege modes. Instantiates the
// pmp_registers DUT and drives its internal signals to verify correct register behavior and access control.
//
// Dependencies:
// - pmp_registers.sv : Implements PMP configuration and address register storage.
// - cep_define       : Package containing PMP definitions.
//
// Author: Muhammad Furrukh
// Date: 

import cep_define ::*;
module pmp_registers_tb();
  logic                 clock, reset, wr_en;
  logic          [1:0]  priv_mode;
  logic          [31:0] wdata;
  logic unsigned [31:0] rw_addr;
  logic          [31:0] rdata;
  logic unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,  pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,
                        pmpaddr5_data,  pmpaddr6_data,  pmpaddr7_data,  pmpaddr8_data,  pmpaddr9_data,
                        pmpaddr10_data, pmpaddr11_data, pmpaddr12_data, pmpaddr13_data, pmpaddr14_data,
                        pmpaddr15_data;
  logic          [31:0] pmpcfg0_data,   pmpcfg1_data,   pmpcfg2_data,   pmpcfg3_data;

  pmp_registers DUT(.*);

  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    // Testing writing operation on registers
    reset = 1'b1; priv_mode = 2'b00; wr_en = 1'b1; wdata = ((32'b1)<< 15); rw_addr = CSR_PMPCFG0;
    @(negedge clock)
    reset = 1'b0;
    // L1 set -> Locking pmp_cfg0 and pmp_addr1 registers
    @(negedge clock)
    wr_en = 1'b1; wdata = 32'hA; 
    @(negedge clock)
    rw_addr = CSR_PMPADDR0;
    @(negedge clock)
    rw_addr = CSR_PMPADDR1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR2;
    @(negedge clock)
    rw_addr = CSR_PMPADDR3;
    @(negedge clock)
    // Testing write on different privelege modes
    @(negedge clock)
    priv_mode = 2'b01; rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    priv_mode = 2'b10; rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    priv_mode = 2'b00; rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    wr_en = 1'b0;

    // Testing read operation on registers
    // M mode
    @(negedge clock)
    rw_addr = CSR_PMPCFG0;
    @(negedge clock)
    rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR0;
    @(negedge clock)
    rw_addr = CSR_PMPADDR1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR2;
    @(negedge clock)
    rw_addr = CSR_PMPADDR3;
    @(negedge clock)
    // S mode
    priv_mode = 2'b01; rw_addr = CSR_PMPCFG0;
    @(negedge clock)
    rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR0;
    @(negedge clock)
    rw_addr = CSR_PMPADDR1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR2;
    @(negedge clock)
    rw_addr = CSR_PMPADDR3;
    @(negedge clock)
    // U mode
     priv_mode = 2'b11; rw_addr = CSR_PMPCFG0;
    @(negedge clock)
    rw_addr = CSR_PMPCFG1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR0;
    @(negedge clock)
    rw_addr = CSR_PMPADDR1;
    @(negedge clock)
    rw_addr = CSR_PMPADDR2;
    @(negedge clock)
    rw_addr = CSR_PMPADDR3;
    @(negedge clock)
    $stop;
  end
endmodule