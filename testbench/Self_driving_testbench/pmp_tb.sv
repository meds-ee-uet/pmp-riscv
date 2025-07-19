// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description:
// Self-driving testbench for the top-level PMP (Physical Memory Protection) module. Randomizes and applies
// a wide range of configuration, address, privilege mode, and access type combinations to the PMP module.
// Automatically performs read and write operations on PMP configuration and address registers, and verifies
// memory access permissions and correct PMP behavior using assertions.
//
// Dependencies:
// - pmp.sv         : Top-level PMP module.
// - cep_define     : Package containing PMP definitions.
//
// Author: Muhammad Furrukh, Muhammad Boota
// Date: 

import cep_define ::*;
class rand_class;
    rand bit [1:0]  size;
    rand bit [1:0]  oper;
    rand bit [1:0]  priv_mode;
    rand bit [31:0] wdata_config;
    rand bit [31:0] wdata_addr;
    rand bit [31:0] addr;

    constraint size_constraint { 
        size inside {2'd0, 2'd1, 2'd3};
    }
    constraint oper_constraint {
        oper inside {2'd0, 2'd1, 2'd2};
    }
    constraint priv_mode_constraint {
        priv_mode inside {[2'd0:2'd2]};
    }
    constraint wdata__addr_constraint { 
        wdata_addr inside {[32'd0:32'd255]};
        wdata_addr % 32'd16 == 0;
    }
endclass

module pmp_tb #(parameter NUM_OF_TEST = 10000) ();
    logic                 clock, reset, wr_en;
    logic          [1:0]  priv_mode, size, oper, permission;
    logic          [31:0] wdata, rdata;
    logic unsigned [31:0] rw_addr, addr, base, offset;    
    pmpcfg                _cfg[15:0];      // Array of 16 pmpcfg structures (for each entry 8 bits): _cfg[0] to _cfg[15]
    logic          [5:0]  width;     
    logic unsigned [31:0] _pmpaddr[15:0];  // Array of 16 32-bit PMP address registers: _pmpaddr[0] to _pmpaddr[15]
    logic          [31:0] _pmpcfg[3:0];    // Array of 4 32-bit PMP config registers: _pmpcfg[0] to _pmpcfg[3]

    assign {_cfg[3],  _cfg[2],  _cfg[1],  _cfg[0]}    = _pmpcfg[0];
    assign {_cfg[7],  _cfg[6],  _cfg[5],  _cfg[4]}    = _pmpcfg[1];
    assign {_cfg[11], _cfg[10], _cfg[9],  _cfg[8]}    = _pmpcfg[2];
    assign {_cfg[15], _cfg[14], _cfg[13], _cfg[12]}   = _pmpcfg[3];

    // Instantiate the PMP module
    pmp PMP(.*);

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Toggle clock every 5ns (100MHz clock)
    end

    // Reset and test sequence
    initial begin
        // Initialize all inputs
        reset     = 1'b1;
        _pmpcfg   = {8'b0, 8'b0, 8'b0, 8'b0};
        _pmpaddr  = {32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0,
                     32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0};
        oper      = 2'b00;
        wr_en     = 1'b0;
        priv_mode = 2'b01;
        size      = 2'b00;
        wdata     = 32'b0;
        rw_addr   = 32'b0;
        addr      = 32'b0;
        base      = 32'b0;
        offset    = 32'b0;
        width     = 6'b0;

        @(posedge clock)
        reset = 1'b0;

        @(posedge clock)
        pmp_test(NUM_OF_TEST);

        @(posedge clock)
        $stop;
    end

    task automatic pmp_test(input int test_num);
        for (int j = 0; j <= test_num; j++) begin
            pmp_register_read_write();
            repeat(10) begin
                rand_class a;
                a = new();
                a.randomize();
                addr      = a.addr;
                priv_mode = a.priv_mode;
                size      = a.size;
                oper      = a.oper;
                #10

                pmp_check();
                #10;
            end
            #10;

            reset     = 1'b1;
            _pmpcfg   = {8'b0, 8'b0, 8'b0, 8'b0};
            _pmpaddr  = {32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 
                         32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0};
            oper      = 2'b00;
            wr_en     = 1'b0;
            priv_mode = 2'b01;
            size      = 2'b00;
            wdata     = 32'b0;
            rw_addr   = 32'b0;
            addr      = 32'b0;
            #10;

            reset = 1'b0;
        end
    endtask

    task automatic pmp_check();
        for (int k = 0; k < 16; k++) begin
            case (_cfg[k].A)
                TOR: begin
                    if (k == 0) begin
                        if ((0 <= addr) && ((addr + size) < _pmpaddr[k])) begin
                            #10;
                            permission_check(k);
                        end
                    end 
                    
                    else if ((_pmpaddr[k-1] <= addr) && ((addr + size) < _pmpaddr[k])) begin
                        #10;
                        permission_check(k);
                        break;
                    end
                end

                NA4: begin
                    if ((_pmpaddr[k] <= addr) && ((addr + size) < (_pmpaddr[k] + 4))) begin
                        #10;
                        permission_check(k);
                        break;
                    end 
                end

                NAPOT: begin
                    // NAPOT requires encoded size in address bits
                    casez (_pmpaddr[k])  // casez allows ? for don't-care bits
                        32'b???????????????????????????????0: width = 6'd0;
                        32'b??????????????????????????????01: width = 6'd1;
                        32'b?????????????????????????????011: width = 6'd2;
                        32'b????????????????????????????0111: width = 6'd3;
                        32'b???????????????????????????01111: width = 6'd4;
                        32'b??????????????????????????011111: width = 6'd5;
                        32'b?????????????????????????0111111: width = 6'd6;
                        32'b????????????????????????01111111: width = 6'd7;
                        32'b???????????????????????011111111: width = 6'd8;
                        32'b??????????????????????0111111111: width = 6'd9;
                        32'b?????????????????????01111111111: width = 6'd10;
                        32'b????????????????????011111111111: width = 6'd11;
                        32'b???????????????????0111111111111: width = 6'd12;
                        32'b??????????????????01111111111111: width = 6'd13;
                        32'b?????????????????011111111111111: width = 6'd14;
                        32'b????????????????0111111111111111: width = 6'd15;
                        32'b???????????????01111111111111111: width = 6'd16;
                        32'b??????????????011111111111111111: width = 6'd17;
                        32'b?????????????0111111111111111111: width = 6'd18;
                        32'b????????????01111111111111111111: width = 6'd19;
                        32'b???????????011111111111111111111: width = 6'd20;
                        32'b??????????0111111111111111111111: width = 6'd21;
                        32'b?????????01111111111111111111111: width = 6'd22;
                        32'b????????011111111111111111111111: width = 6'd23;
                        32'b???????0111111111111111111111111: width = 6'd24;
                        32'b??????01111111111111111111111111: width = 6'd25;
                        32'b?????011111111111111111111111111: width = 6'd26;
                        32'b????0111111111111111111111111111: width = 6'd27;
                        32'b???01111111111111111111111111111: width = 6'd28;
                        32'b??011111111111111111111111111111: width = 6'd29;
                        32'b?0111111111111111111111111111111: width = 6'd30;
                        32'b01111111111111111111111111111111: width = 6'd31;
                        32'b11111111111111111111111111111111: width = 6'd32;
                        default: width = 6'd0;  // When no bits are set
                    endcase
                    base   = _pmpaddr[k] & ((32'hFFFFFFFF) << width);
                    offset = 8 << width;
                    if ((base <= addr) && ((addr + size) < (base + offset))) begin
                        #10;
                        permission_check(k);
                        break;
                    end
                end

                default: begin end
            endcase
            #10;
        end
    endtask

//************Read & WRITE FUNCTION*************// 
    task automatic pmp_register_read_write();
        // Checking read and write on address registers (no L-bit set)
        priv_mode = 2'b00; 
        rw_addr   = 12'h3B0 + 16; 
        wr_en     = 1'b1;

        for (int i = 0; i < 16; i++) begin
            rand_class a;
            a = new();
            a.randomize();
            #10;

            wdata   = a.wdata_addr;
            rw_addr = 12'h3B0 + i; 
            if (_cfg[i].L == 1'b0) 
                _pmpaddr[i] = wdata;
            $display("wdata = %0x, rw_addr = %0x", wdata, rw_addr);
        end
        #10;

        wr_en = 1'b0;
        for (int i = 0; i < 16; i++) begin
            rw_addr = 12'h3B0 + i;
            #10;

            assert(rdata == _pmpaddr[i]);
            #10;
        end

        // Checking read and write on config registers (no L-bit)
        rw_addr = 12'h3B0 + 16; 
        wr_en   = 1'b1; 
        for (int i = 0; i < 4; i++) begin
            rand_class a;
            a = new();
            a.randomize();
            #10;

            wdata   = a.wdata_config;
            rw_addr = 12'h3A0 + i;
            if (_pmpcfg[i][7]  == 1'b0 && _pmpcfg[i][15] == 1'b0 && 
                _pmpcfg[i][23] == 1'b0 && _pmpcfg[i][31] == 1'b0) 
                _pmpcfg[i] = wdata;
            $display("wdata = %0x, rw_addr = %0x", wdata, rw_addr);
        end 
        #10;

        wr_en = 1'b0;
        for (int i = 0; i < 4; i++) begin
            rw_addr = 12'h3A0 + i;
            #10;

            assert(rdata == _pmpcfg[i]);
            #10;
        end

        // Checking read and write on address registers (Probably some L-bits enabled)
        rw_addr = 12'h3B0 + 16; 
        wr_en  = 1'b1;
        for (int i = 0; i < 16; i++) begin
            rand_class a;
            a = new();
            a.randomize();
            #10;

            wdata   = a.wdata_addr;
            rw_addr = 12'h3B0 + i; 
            if (_cfg[i].L == 1'b0) 
                _pmpaddr[i] = wdata;
            $display("wdata = %0x, rw_addr = %0x", wdata, rw_addr);
        end
        #10;

        wr_en = 1'b0;
        for (int i = 0; i < 16; i++) begin
            rw_addr = 12'h3B0 + i;
            #10;

            assert(rdata == _pmpaddr[i]);
            #10;
        end

        // Checking read and write on config registers (Probably some L-bits enabled)
        rw_addr = 12'h3B0 + 16; 
        wr_en   = 1'b1; 
        for (int i = 0; i < 4; i++) begin
            rand_class a;
            a = new();
            a.randomize();
            #10;

            wdata   = a.wdata_config;
            rw_addr = 12'h3A0 + i;
            if (_pmpcfg[i][7]  == 1'b0 && _pmpcfg[i][15] == 1'b0 && 
                _pmpcfg[i][23] == 1'b0 && _pmpcfg[i][31] == 1'b0) 
                _pmpcfg[i] = wdata;
            $display("wdata = %0x, rw_addr = %0x", wdata, rw_addr);
        end 
        #10;

        wr_en = 1'b0;
        for (int i = 0; i < 4; i++) begin
            rw_addr = 12'h3A0 + i;
            #10;

            assert(rdata == _pmpcfg[i]);
            #10;
        end

        priv_mode = 2'b1;
    endtask

    task automatic permission_check(input logic[3:0] num);
        case (oper)
            2'b00: assert((_cfg[num].R == 1'b1 && permission == 2'b11) || 
                          (_cfg[num].R == 1'b0 && permission == oper));
            2'b01: assert((_cfg[num].W == 1'b1 && permission == 2'b11) ||
                          (_cfg[num].W == 1'b0 && permission == oper));
            2'b10: assert((_cfg[num].X == 1'b1 && permission == 2'b11) || 
                          (_cfg[num].X == 1'b0 && permission == oper)); 
            default: assert(1 == 0);
        endcase;
    endtask
endmodule