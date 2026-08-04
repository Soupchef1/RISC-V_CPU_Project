`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: Ryan and Ben
// 
// Create Date: 08/02/2026 03:41:10 PM
// Design Name: CPU_top
// Module Name: CPU_top
// Project Name: GOON-PU
// Target Devices: Spartan 7
// Tool Versions: 
// Description: 
// 
// Dependencies: brain
// 
// Revision: 11120020103012001
// Revision 0.01 - File Created
// Additional Comments: Trip is fried af gng
// 
//////////////////////////////////////////////////////////////////////////////////

import ctrl_signal_pkg::*;

module CPU_top(

        input logic clk, nrst,

        //to Mem controller
        output logic [31:0] ins_addr,
        output logic ins_rd_miss,
        input logic [511:0] ins_data_out, //coming in to cache

        output logic [31:0] data_addr,
        output logic [511:0] data_data_in, //data coming  from cache
        input logic [511:0] data_data_out, //correct data going into cache
        output logic data_rd_miss,
        output logic data_wr_miss,
        output logic data_dirty,
        output logic video_data,

        input logic ins_read_done,
        input logic data_read_done,

        // from bootloader
        input logic start_valid, start_write_en,
        input logic start_done,
        input logic [31:0] start_addr,
        input logic [31:0] start_data,

        //to vdma
        output logic buffer_change

    );


    //internal signals
    logic flush, stall;
    logic data_cache_stall, ins_cache_stall;
    
    //Instruction Fetch
    logic [31:0] IF_instr, IF_PC; 
    logic IF_predicted_jump;

    //Instruction Decode
    logic [4:0] ID_MUX_en, ID_rd;
    logic [31:0] ID_instr, ID_PC, ID_rs1_data, ID_rs2_data, ID_imm;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [4:0] rs1_addr, rs2_addr, opcode;
    ctrl_signal_t ID_ctrl_signals;

    //Execute
    logic [31:0] EX_PC, EX_ALU_out, EX_rs2_data;
    logic [4:0] EX_rd;
    logic [3:0] FUmux;
    logic pc_switch;
    logic [31:0] PC_next, target;
    ctrl_signal_t EX_ctrl_signals;

    //Memory Access
    logic [31:0] MA_data_out;
    logic [4:0] MA_rd;
    ctrl_signal_t MA_ctrl_signals;

    //Write Back
    logic [31:0] WB_data_out;
    logic [4:0] WB_rd;
    logic WB_en;



    IF_top squid (
        .clk(clk),
        .nrst(nrst),
        .flush(flush),
        .stall(stall),
        .PC_next(PC_next),
        .instr(IF_instr),
        .PC_out(IF_PC), //to decode pipeline reg

        //branch mem signals
        .predicted_jump(IF_predicted_jump),
        .MUX_en(ID_MUX_en),
        .pc_switch(pc_switch),
        .PC_Ex(EX_PC),
        .target(target),

        //instruction cache signals
        .ID_addr(ID_PC),
        .start_data(start_data),
        .start_addr(start_addr),
        .start_done(start_done),
        .start_valid(start_valid),
        .start_write_en(start_write_en),
        .ddr_rd_done(ins_read_done),
        .ddr_data_in(ins_data_out),
        .ddr_rd_miss(ins_rd_miss),
        .ddr_addr(ins_addr),
        .stall_out(ins_cache_stall)
    );


    ID_top plank ( 
        //global signals
        .clk(clk),
        .nrst(nrst),

        //decode signals 
        .PC_in(IF_PC),
        .instr_in(IF_instr),
        .PC_out(ID_PC),
        .rs1_data(ID_rs1_data),
        .rs2_data(ID_rs2_data),
        .imm(ID_imm),
        .rd(ID_rd),
        
        //write back signals
        .wb_en(WB_en),
        .wb_addr(WB_rd),
        .wb_data(WB_data_out),

        //controller signals
        .flush_en(flush),
        .stall_en(stall),
        .func3(func3),
        .func7(func7),
        .opcode(opcode),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr)
      
    );

    forwardingUnit jett (
        .rs1_decode(rs1_addr),
        .rs2_decode(rs2_addr),
        .rd_ex(EX_rd),
        .rd_mem(MA_rd),
        .FUmux(FU_mux)
    );

     EX_top sponge (
        .clk(clk),
        .nrst(nrst),
        .pc(ID_PC),
        .rs1_data(ID_rs1_data),
        .rs2_data(ID_rs2_data),
        .imm(ID_imm),
        .MUX_en(EX_ctrl_signals.MUX_en),
        .ALU_op(EX_ctrl_signals.ALU_op),
        .ALU_out(EX_ALU_out),
        .target(target),
        .pc_next(PC_next),
        .pc_switch(pc_switch),
        .FUmux(FUmux),
        .ALU_outex(MA_data_out),
        .ALU_outmem(WB_data_out),
        .PC_D(EX_PC),
        .rs2_data_o(EX_rs2_data),
        .flush_en(flush),
        .stall_en(stall)
    );

    MEM_TOP star (
        .clk(clk),
        .nrst(nrst),
        .EX_rd(EX_rd),
        .EX_addr(EX_ALU_out),
        .EX_data(EX_rs2_data),
        .EX_mem_bytes(EX_ctrl_signals.mem_bytes),
        .MA_mem_bytes(MA_ctrl_signals.mem_bytes),
        .mem_zero_extend(MA_ctrl_signals.mem_zero_extend),
        .EX_rd_en(EX_ctrl_signals.mem_read),
        .EX_wr_en(EX_ctrl_signals.mem_write),
        .MA_rd_en(MA_ctrl_signals.mem_read),
        .MA_wr_en(MA_ctrl_signals.mem_write),
        .stall_out(data_cache_stall),
        .ddr_rd_done(data_read_done),
        .ddr_data_in(data_data_out),
        .ddr_wr_miss(data_wr_miss),
        .ddr_rd_miss(data_rd_miss),
        .ddr_data_out(data_data_in),
        .ddr_addr(data_addr),
        .ddr_dirty(data_dirty),
        .is_video_data(video_data),
        .flush(flush),
        .stall(stall),
        .MUX_data_out(MA_data_out),
        .mem_rd(MA_rd),
        .start_addr(start_addr),
        .start_done(start_done),
        .buffer_change(buffer_change)
    );

    WB_top crabs(
        .clk(clk),
        .nrst(nrst),
        .ALU_out(MA_data_out),
        .rd(MA_rd),
        .stall(stall),
        .ALU_outmem(WB_data_out),
        .rd_mem(WV_rd)
    );

    main_controller puffs(
        .clk(clk),
        .nrst(nrst),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .predicted_jump_fetch(IF_predicted_jump),
        .pc_switch(pc_switch),
        .stall_inst(ins_cache_stall),
        .stall_data_cache(data_cache_stall),
        .flush(flush),
        .stall_out(stall),
        .decode_ctrl(ID_ctrl_signals),
        .ex_ctrl(EX_ctrl_signals),
        .mem_ctrl(MA_ctrl_signals),
        .write_back_ctrl(WB_en)
    );


endmodule
