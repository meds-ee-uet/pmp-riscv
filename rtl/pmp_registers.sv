// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// This module implements the register file for RISC-V Physical Memory Protection (PMP).
// It includes 16 PMP address registers (`pmpaddr0` to `pmpaddr15`) and 4 PMP configuration 
// registers (`pmpcfg0` to `pmpcfg3`). The module supports both read and write access to 
// these registers through the standard RISC-V CSR interface.
//
// Write access is only allowed in Machine mode (`priv_mode == 2'b00`), and only when the 
// corresponding PMP entry is not locked (L-bit = 0). If the lock bit for any 8-bit PMP 
// configuration field is set, writes to both the configuration and associated address 
// registers are blocked.
//
// Read access is also restricted to Machine mode and is only allowed when `wr_en == 0`.
//
// Inputs:
// - clock           :                      Clock signal.
// - reset           :                      Asynchronous active-high reset.
// - wr_en           :                      Write enable signal.
// - priv_mode       : [1:0]                Current processor privilege level
//                                          (00: M-mode, 01: S-mode, 10: U-mode).
// - wdata           : [31:0]               Data to be written to the selected PMP CSR.
// - rw_addr         : [31:0] (unsigned)    Address of the CSR to read/write.
//
// Outputs:
// - pmpaddr*_data   : [31:0] (unsigned)    Contents of PMP address registers 0–15.
// - pmpcfg*_data    : [31:0]               Contents of PMP configuration registers 0–3.
// - rdata           : [31:0]               Data read from the addressed PMP CSR.
//
// Behavior:
// - Resets all PMP configuration and address registers to zero on reset.
// - During write operations, checks the lock bit (`L`) for each PMP entry before allowing writes.
// - Allows read access only in Machine mode and when not writing.
//
// Dependencies:
// - `cep_define.sv` : Package file
//
// Author: Muhammad Boota & Muhammad Furrukh
// Date:

import cep_define ::*;
module pmp_registers (
    input  logic                 clock, reset, wr_en,
    input  logic          [1:0]  priv_mode,
    input  logic          [31:0] wdata,
    input  logic unsigned [31:0] rw_addr,
    output logic          [31:0] rdata,
    output logic unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,  pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,   pmpaddr5_data,
                                 pmpaddr6_data,  pmpaddr7_data,  pmpaddr8_data,  pmpaddr9_data,  pmpaddr10_data,  pmpaddr11_data,
                                 pmpaddr12_data, pmpaddr13_data, pmpaddr14_data, pmpaddr15_data,
    output logic          [31:0] pmpcfg0_data,   pmpcfg1_data,   pmpcfg2_data,   pmpcfg3_data
);

     
    logic unsigned [31:0] pmpaddr0, pmpaddr1, pmpaddr2,  pmpaddr3,  pmpaddr4,  pmpaddr5,  pmpaddr6,  pmpaddr7,
                          pmpaddr8, pmpaddr9, pmpaddr10, pmpaddr11, pmpaddr12, pmpaddr13, pmpaddr14, pmpaddr15;

    logic          [31:0] pmpcfg0, pmpcfg1, pmpcfg2, pmpcfg3;

    always_ff @(posedge clock) begin
        if (reset)begin
            pmpcfg0   <= 32'b0;
            pmpcfg1   <= 32'b0;
            pmpcfg2   <= 32'b0;
            pmpcfg3   <= 32'b0;

            pmpaddr0  <= 32'b0;
            pmpaddr1  <= 32'b0;
            pmpaddr2  <= 32'b0;
            pmpaddr3  <= 32'b0;
            pmpaddr4  <= 32'b0;
            pmpaddr5  <= 32'b0;
            pmpaddr6  <= 32'b0;
            pmpaddr7  <= 32'b0;
            pmpaddr8  <= 32'b0;
            pmpaddr9  <= 32'b0;
            pmpaddr10 <= 32'b0;
            pmpaddr11 <= 32'b0;
            pmpaddr12 <= 32'b0;
            pmpaddr13 <= 32'b0;
            pmpaddr14 <= 32'b0;
            pmpaddr15 <= 32'b0;
        end
        else if (wr_en && (priv_mode == 2'b0)) begin
            case (rw_addr)
                CSR_PMPCFG0:
                    if (~(pmpcfg0[7]  || pmpcfg0[15] || pmpcfg0[23] || pmpcfg0[31]))
                        pmpcfg0 <= wdata;
            
                CSR_PMPCFG1:
                    if (~(pmpcfg1[7]  || pmpcfg1[15] || pmpcfg1[23] || pmpcfg1[31]))
                        pmpcfg1 <= wdata;
            
                CSR_PMPCFG2:
                    if (~(pmpcfg2[7]  || pmpcfg2[15] || pmpcfg2[23] || pmpcfg2[31]))
                        pmpcfg2 <= wdata;
            
                CSR_PMPCFG3:
                    if (~(pmpcfg3[7]  || pmpcfg3[15] || pmpcfg3[23] || pmpcfg3[31]))
                        pmpcfg3 <= wdata;
                
                CSR_PMPADDR0:
                    if (~pmpcfg0[7])        
                        pmpaddr0  <= wdata;
                CSR_PMPADDR1:
                    if (~pmpcfg0[15])       
                        pmpaddr1  <= wdata;
                CSR_PMPADDR2:
                    if (~pmpcfg0[23])       
                        pmpaddr2  <= wdata;
                CSR_PMPADDR3:
                    if (~pmpcfg0[31])       
                        pmpaddr3  <= wdata;
            
                CSR_PMPADDR4:
                    if (~pmpcfg1[7])        
                        pmpaddr4  <= wdata;
                CSR_PMPADDR5:
                    if (~pmpcfg1[15])       
                        pmpaddr5  <= wdata;
                CSR_PMPADDR6:
                    if (~pmpcfg1[23])       
                        pmpaddr6  <= wdata;
                CSR_PMPADDR7:
                    if (~pmpcfg1[31])       
                        pmpaddr7  <= wdata;
            
                CSR_PMPADDR8:
                    if (~pmpcfg2[7])        
                        pmpaddr8  <= wdata;
                CSR_PMPADDR9:
                    if (~pmpcfg2[15])       
                        pmpaddr9  <= wdata;
                CSR_PMPADDR10:
                    if (~pmpcfg2[23])       
                        pmpaddr10 <= wdata;
                CSR_PMPADDR11:
                    if (~pmpcfg2[31])       
                        pmpaddr11 <= wdata;
            
                CSR_PMPADDR12:
                    if (~pmpcfg3[7])        
                        pmpaddr12 <= wdata;
                CSR_PMPADDR13:
                    if (~pmpcfg3[15])       
                        pmpaddr13 <= wdata;
                CSR_PMPADDR14:
                    if (~pmpcfg3[23])       
                        pmpaddr14 <= wdata;
                CSR_PMPADDR15:
                    if (~pmpcfg3[31])       
                        pmpaddr15 <= wdata;
            
                default: /* do nothing */;
            endcase
        end
    end

    always_comb begin
        if (priv_mode==2'b0 && !(wr_en)) begin
            case (rw_addr)
                // PMP Configuration CSRs
                CSR_PMPCFG0:   rdata = pmpcfg0;
                CSR_PMPCFG1:   rdata = pmpcfg1;
                CSR_PMPCFG2:   rdata = pmpcfg2;
                CSR_PMPCFG3:   rdata = pmpcfg3;
            
                // PMP Address CSRs
                CSR_PMPADDR0:  rdata = pmpaddr0;
                CSR_PMPADDR1:  rdata = pmpaddr1;
                CSR_PMPADDR2:  rdata = pmpaddr2;
                CSR_PMPADDR3:  rdata = pmpaddr3;
                CSR_PMPADDR4:  rdata = pmpaddr4;
                CSR_PMPADDR5:  rdata = pmpaddr5;
                CSR_PMPADDR6:  rdata = pmpaddr6;
                CSR_PMPADDR7:  rdata = pmpaddr7;
                CSR_PMPADDR8:  rdata = pmpaddr8;
                CSR_PMPADDR9:  rdata = pmpaddr9;
                CSR_PMPADDR10: rdata = pmpaddr10;
                CSR_PMPADDR11: rdata = pmpaddr11;
                CSR_PMPADDR12: rdata = pmpaddr12;
                CSR_PMPADDR13: rdata = pmpaddr13;
                CSR_PMPADDR14: rdata = pmpaddr14;
                CSR_PMPADDR15: rdata = pmpaddr15;
                default:       rdata = 32'b0;
            endcase
        end 
        else rdata = 32'b0;
    end

    assign pmpcfg0_data   = pmpcfg0;
    assign pmpcfg1_data   = pmpcfg1;
    assign pmpcfg2_data   = pmpcfg2;
    assign pmpcfg3_data   = pmpcfg3;
    
    // Assigning PMP address outputs
    assign pmpaddr0_data  = pmpaddr0;
    assign pmpaddr1_data  = pmpaddr1;
    assign pmpaddr2_data  = pmpaddr2;
    assign pmpaddr3_data  = pmpaddr3;
    assign pmpaddr4_data  = pmpaddr4;
    assign pmpaddr5_data  = pmpaddr5;
    assign pmpaddr6_data  = pmpaddr6;
    assign pmpaddr7_data  = pmpaddr7;
    assign pmpaddr8_data  = pmpaddr8;
    assign pmpaddr9_data  = pmpaddr9;
    assign pmpaddr10_data = pmpaddr10;
    assign pmpaddr11_data = pmpaddr11;
    assign pmpaddr12_data = pmpaddr12;
    assign pmpaddr13_data = pmpaddr13;
    assign pmpaddr14_data = pmpaddr14;
    assign pmpaddr15_data = pmpaddr15;
endmodule