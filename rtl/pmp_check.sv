// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// This module checks whether a given memory access (address and operation) is protected by 
// any of the 16 PMP (Physical Memory Protection) entries, as defined in the RISC-V privilege 
// specification. If a match is found, it determines whether the intended operation (read, write, 
// or execute) is permitted based on the configuration of the matched entry.
//
// Inputs:
// - pmpaddr*_data       : [31:0] (unsigned) Contents of PMP address registers 0-15
// - pmpcfg*_data        : [31:0]            Contents of PMP configuration registers 0-3
// - addr                : [31:0] (unsigned) Base address of the memory region to be accessed.
// - size                : [1:0]             Size of the memory access (00: byte, 01: half-word, 10: word).
// - priv_mode           : [1:0]             Current processor privilege level
//                                           (00: M-mode, 01: S-mode, 10: U-mode) 
// - oper                : [1:0]             Operation to be performed on data in the accessed memory region
//                                           (00: Read, 01: Write, 10: Execute)          
// Output:
// - permission          : [1:0]             Permission granted or a specific type of fault 
//                                           (00: Read fault, 01: Write fault, 10: Execute fault, 11: Permission granted)
// Dependencies:
// - `cep_define.sv`     : Package file
// - addr_check_n        : Determines whether a given memory address falls within the protection range of the nth Physical 
//                         Memory Protection (PMP) entry
// Notes:
// - This module performs priority resolution among PMP entries, with lower-numbered entries 
//   having higher priority.
// - Implements lock bit behavior and privilege mode restrictions as per the RISC-V PMP specification.
//
// Author: Muhammad Boota, Muhammad Furrukh
// Date:

import cep_define::*;
module pmp_check (
    input  logic     unsigned [31:0] pmpaddr0_data,  pmpaddr1_data,   pmpaddr2_data,  pmpaddr3_data,  pmpaddr4_data,  pmpaddr5_data,
                                     pmpaddr6_data,  pmpaddr7_data,   pmpaddr8_data,  pmpaddr9_data,  pmpaddr10_data, pmpaddr11_data,
                                     pmpaddr12_data, pmpaddr13_data,  pmpaddr14_data, pmpaddr15_data,
    input  logic              [31:0] pmpcfg0_data,   pmpcfg1_data,    pmpcfg2_data,   pmpcfg3_data,
    input  logic              [1:0]  size,
    input  logic              [1:0]  priv_mode, oper,
    input  logic     unsigned [31:0] addr,
    output logic              [1:0]  permission
);
    
    logic          out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15; 
    logic   [1:0]  pre_permission;
    logic   [15:0] pri;
    logic   [4:0]  entry_num;
    logic   [31:0] pmpcfg_reg_selected;
    logic          oper_permission,   pre_lock;
    pmpcfg         pmp0cfg, pmp1cfg,  pmp2cfg,  pmp3cfg,  pmp4cfg,  pmp5cfg,  pmp6cfg,  pmp7cfg, 
                   pmp8cfg, pmp9cfg,  pmp10cfg, pmp11cfg, pmp12cfg, pmp13cfg, pmp14cfg, pmp15cfg;
    pmpcfg         pmpcfg_selected;


    assign {pmp3cfg,  pmp2cfg,  pmp1cfg,  pmp0cfg}   = pmpcfg0_data;
    assign {pmp7cfg,  pmp6cfg,  pmp5cfg,  pmp4cfg}   = pmpcfg1_data;
    assign {pmp11cfg, pmp10cfg, pmp9cfg,  pmp8cfg}   = pmpcfg2_data;
    assign {pmp15cfg, pmp14cfg, pmp13cfg, pmp12cfg}  = pmpcfg3_data;


    addr_check_n Addr_Check_0 (.addr, .a_n(pmp0cfg.A),  .addr_n_1(32'b0),          .addr_n(pmpaddr0_data),  .size, .out(out0));
    addr_check_n Addr_Check_1 (.addr, .a_n(pmp1cfg.A),  .addr_n_1(pmpaddr0_data),  .addr_n(pmpaddr1_data),  .size, .out(out1));
    addr_check_n Addr_Check_2 (.addr, .a_n(pmp2cfg.A),  .addr_n_1(pmpaddr1_data),  .addr_n(pmpaddr2_data),  .size, .out(out2));
    addr_check_n Addr_Check_3 (.addr, .a_n(pmp3cfg.A),  .addr_n_1(pmpaddr2_data),  .addr_n(pmpaddr3_data),  .size, .out(out3));
    addr_check_n Addr_Check_4 (.addr, .a_n(pmp4cfg.A),  .addr_n_1(pmpaddr3_data),  .addr_n(pmpaddr4_data),  .size, .out(out4));
    addr_check_n Addr_Check_5 (.addr, .a_n(pmp5cfg.A),  .addr_n_1(pmpaddr4_data),  .addr_n(pmpaddr5_data),  .size, .out(out5));
    addr_check_n Addr_Check_6 (.addr, .a_n(pmp6cfg.A),  .addr_n_1(pmpaddr5_data),  .addr_n(pmpaddr6_data),  .size, .out(out6));
    addr_check_n Addr_Check_7 (.addr, .a_n(pmp7cfg.A),  .addr_n_1(pmpaddr6_data),  .addr_n(pmpaddr7_data),  .size, .out(out7));
    addr_check_n Addr_Check_8 (.addr, .a_n(pmp8cfg.A),  .addr_n_1(pmpaddr7_data),  .addr_n(pmpaddr8_data),  .size, .out(out8));
    addr_check_n Addr_Check_9 (.addr, .a_n(pmp9cfg.A),  .addr_n_1(pmpaddr8_data),  .addr_n(pmpaddr9_data),  .size, .out(out9));
    addr_check_n Addr_Check_10(.addr, .a_n(pmp10cfg.A), .addr_n_1(pmpaddr9_data),  .addr_n(pmpaddr10_data), .size, .out(out10));
    addr_check_n Addr_Check_11(.addr, .a_n(pmp11cfg.A), .addr_n_1(pmpaddr10_data), .addr_n(pmpaddr11_data), .size, .out(out11));
    addr_check_n Addr_Check_12(.addr, .a_n(pmp12cfg.A), .addr_n_1(pmpaddr11_data), .addr_n(pmpaddr12_data), .size, .out(out12));
    addr_check_n Addr_Check_13(.addr, .a_n(pmp13cfg.A), .addr_n_1(pmpaddr12_data), .addr_n(pmpaddr13_data), .size, .out(out13));
    addr_check_n Addr_Check_14(.addr, .a_n(pmp14cfg.A), .addr_n_1(pmpaddr13_data), .addr_n(pmpaddr14_data), .size, .out(out14));
    addr_check_n Addr_Check_15(.addr, .a_n(pmp15cfg.A), .addr_n_1(pmpaddr14_data), .addr_n(pmpaddr15_data), .size, .out(out15));



always_comb begin : priority_circuit
    pri = {out15, out14, out13, out12, out11, out10, out9, out8,
           out7,  out6,  out5,  out4,  out3,  out2,  out1, out0};
    casez (pri)  // casez allows ? for don't-care bits
        16'b???????????????1: entry_num = 5'd0;
        16'b??????????????10: entry_num = 5'd1;
        16'b?????????????100: entry_num = 5'd2;
        16'b????????????1000: entry_num = 5'd3;
        16'b???????????10000: entry_num = 5'd4;
        16'b??????????100000: entry_num = 5'd5;
        16'b?????????1000000: entry_num = 5'd6;
        16'b????????10000000: entry_num = 5'd7;
        16'b???????100000000: entry_num = 5'd8;
        16'b??????1000000000: entry_num = 5'd9;
        16'b?????10000000000: entry_num = 5'd10;
        16'b????100000000000: entry_num = 5'd11;
        16'b???1000000000000: entry_num = 5'd12;
        16'b??10000000000000: entry_num = 5'd13;
        16'b?100000000000000: entry_num = 5'd14;
        16'b1000000000000000: entry_num = 5'd15;
        default:              entry_num = 5'd16;
    endcase
end



always_comb begin : selction_of_pmpcfg_reg_and_entry
    case (entry_num[3:2])
        4'd0:    pmpcfg_reg_selected = pmpcfg0_data;
        4'd1:    pmpcfg_reg_selected = pmpcfg1_data;
        4'd2:    pmpcfg_reg_selected = pmpcfg2_data;
        4'd3:    pmpcfg_reg_selected = pmpcfg3_data;
        default: pmpcfg_reg_selected = 32'b0;
    endcase
    
    case (entry_num[1:0])
        4'd0:    pmpcfg_selected     = pmpcfg_reg_selected[7:0];
        4'd1:    pmpcfg_selected     = pmpcfg_reg_selected[15:8];
        4'd2:    pmpcfg_selected     = pmpcfg_reg_selected[23:16];
        4'd3:    pmpcfg_selected     = pmpcfg_reg_selected[31:24];
        default: pmpcfg_selected = 8'b0;
    endcase

    if (entry_num != 5'd16) begin
    case (oper)
        2'b00:   oper_permission   = pmpcfg_selected.R;
        2'b01:   oper_permission   = pmpcfg_selected.W;
        2'b10:   oper_permission   = pmpcfg_selected.X;
        default: oper_permission   = 1'b0; 
    endcase
    end

    else 
        oper_permission = 1'b1;
    end

assign pre_permission = (oper_permission) ? 2'b11 : oper; 
assign pre_lock       = (~pmpcfg_selected.L) && (priv_mode == 2'b0);
assign permission     = (pre_lock) ? {1'b1, pre_lock} : pre_permission;
endmodule