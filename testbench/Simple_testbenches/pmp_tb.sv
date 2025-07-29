// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Testbench for the top-level PMP (Physical Memory Protection) module. Stimulates the PMP module by performing
// write and read operations on configuration and address registers, and verifies memory access permissions under
// different privilege modes and access types. Instantiates the PMP DUT and drives its internal signals to
// validate correct PMP behavior.
//
// Dependencies:
// - pmp.sv         : Top-level PMP module.
// - cep_define     : Package containing PMP definitions.
//
// Author: Muhammad Boota, Waleed Tariq
// Date: 

import cep_define ::*;
module pmp_tb();
  logic         clock, reset, wr_en;
  logic  [1:0]  priv_mode, size, oper, permission;
  logic  [31:0] wdata, rw_addr, addr, rdata;
  logic  [31:0] pmpcfg_reg;
  pmpcfg        cfg0, cfg1, cfg2, cfg3;

  assign pmpcfg_reg = {cfg3, cfg2, cfg1, cfg0};

  // Instantiate the PMP module
  pmp PMP(.*);

  // Clock generation
  initial begin
    clock = 0;
    forever #1 clock = ~clock; // Toggle clock every 5ns (100MHz clock)
  end

  // Reset and test sequence
  initial begin
    // Initialize all inputs
    reset     = 1'b1;
    oper      = READ;
    wr_en     = 1'b0;
    priv_mode = 2'b01;
    size      = 2'b00;
    wdata     = 32'b0;
    rw_addr   = 32'b0;
    addr      = 32'b0;
    // Initialize PMP configs
    cfg0 = '{default:0};
    cfg1 = '{default:0};
    cfg2 = '{default:0};
    cfg3 = '{default:0};

    // Apply reset
    #4;
    @(posedge clock)
    reset = 1'b0;

    // Test case 1: tor mode - Machine mode access
    wr_en = 1'b1;
    oper = WRITE;
    priv_mode = 2'b00; // Machine mode
    rw_addr = CSR_PMPADDR0;
    wdata = 32'h12345678;
    @(posedge clock)
    wr_en = 1'b1;
    rw_addr = CSR_PMPCFG0;
    cfg0.R = 0; cfg0.W = 0; cfg0.X = 0; cfg0.A = TOR; cfg0.L = 0; // OFF mode
    @(posedge clock)
    wdata=pmpcfg_reg;
    @(posedge clock)
    wr_en = 1'b0;
    priv_mode = 2'b01; // Switch to User mode
    @(posedge clock)
    oper = READ; // Should fail in OFF mode
    @(posedge clock)
    oper = WRITE; // Should fail in OFF mode
    @(posedge clock)
    oper = EXECUTE; // Should fail in OFF mode
    @(posedge clock)

    // Test case 2: OFF mode - Locked configuration in Machine mode
    wr_en = 1'b1;
    oper = WRITE;
    priv_mode = 2'b00; // Machine mode
    rw_addr = CSR_PMPADDR1;
    wdata = 32'h20000000;
    @(posedge clock);
    rw_addr = CSR_PMPCFG0;
    cfg1.R = 0; cfg1.W = 1; cfg1.X = 0; cfg1.A = OFF; cfg1.L = 1; // Locked OFF mode
    wdata=pmpcfg_reg;
    @(posedge clock)
    wr_en = 1'b0;
    priv_mode = 2'b01; // Switch to User mode
    @(posedge clock)
    addr=32'h19999988;
    @(posedge clock)
    oper = READ; 
    @(posedge clock)
    oper = WRITE;  
    @(posedge clock)
    oper = EXECUTE; 
    @(posedge clock)

   // // Test case 3: Transition froym TOR mode to OFF mode with no permissions
   wr_en = 1'b1;
   oper = WRITE;
   priv_mode = 2'b00; // Machine mode
   rw_addr = CSR_PMPADDR2;
   wdata = 32'h30000000;
   @(posedge clock)
   wr_en = 1'b1;
   rw_addr = CSR_PMPCFG0;
   cfg2.R = 0; cfg2.W = 0; cfg2.X = 0; cfg2.A = TOR; cfg2.L = 0; // TOR mode with no permissions
   wdata=pmpcfg_reg;
   @(posedge clock)
   wr_en=1'b0;
   priv_mode = 2'b01; // Switch to User mode
   @(posedge clock)
   addr = 32'h29000000;
   @(posedge clock)
   oper = READ; // Should fail in TOR mode
   @(posedge clock)
   oper = WRITE; // Should fail in TOR mode
   @(posedge clock)
   oper = EXECUTE; // Should fail in TOR mode
   @(posedge clock)
   // Transition to OFF mode
   wr_en = 1'b1;
   rw_addr = CSR_PMPCFG0;
   cfg2.R = 0; cfg2.W = 0; cfg2.X = 0; cfg2.A = OFF; cfg2.L = 0; // OFF mode
   wdata=pmpcfg_reg;
   @(posedge clock)
   wr_en = 1'b0;
   priv_mode = 2'b01; // Switch to User mode
   @(posedge clock)
   addr = 32'h29005000;
   @(posedge clock)
   oper = READ; 
   @(posedge clock)
   oper = WRITE; 
   @(posedge clock)
   oper = EXECUTE; 
   @(posedge clock)
  // Test case 4: Transition from OFF mode to TOR mode with no permissions
  wr_en = 1'b1;
  oper = WRITE;
  priv_mode = 2'b00; // Machine mode
  rw_addr = CSR_PMPADDR3;
  wdata = 32'h00003000;
  @(posedge clock)
  wr_en = 1'b0;
  rw_addr = CSR_PMPCFG3;
  cfg3.R = 0; cfg3.W = 0; cfg3.X = 0; cfg3.A = OFF; cfg3.L = 0; // OFF mode
  @(posedge clock)
  oper = READ; // Should fail in OFF mode
  @(posedge clock)
  oper = WRITE; // Should fail in OFF mode
  @(posedge clock)
  oper = EXECUTE; // Should fail in OFF mode
  @(posedge clock)
  // Transition to TOR mode
  wr_en = 1'b1;
  rw_addr = CSR_PMPCFG3;
  cfg3.R = 0; cfg3.W = 0; cfg3.X = 0; cfg3.A = TOR; cfg3.L = 0; // TOR mode with no permissions
  @(posedge clock)
  wr_en = 1'b0;
  @(posedge clock)
  addr = 32'h00003000;
  oper = READ; // Should fail in TOR mode
  @(posedge clock)
  oper = WRITE; // Should fail in TOR mode
  @(posedge clock)
  oper = EXECUTE; // Should fail in TOR mode
  @(posedge clock)
  // Test case 5: OFF mode - Execute-only attempt
  wr_en = 1'b1;
  oper = WRITE;
  priv_mode = 2'b00; // Machine mode
  rw_addr = CSR_PMPADDR0; // Reuse PMPADDR0
  wdata = 32'h00004000;
  @(posedge clock)
  wr_en = 1'b0;
  rw_addr = CSR_PMPCFG0; // Reuse PMPCFG0
  cfg0.R = 0; cfg0.W = 0; cfg0.X = 1; cfg0.A = OFF; cfg0.L = 0; // Execute-only OFF mode
  @(posedge clock)
  priv_mode = 2'b01; // Switch to User mode
  @(posedge clock)
  oper = EXECUTE; // Should fail in OFF mode
  @(posedge clock)

  $stop;
  end
endmodule