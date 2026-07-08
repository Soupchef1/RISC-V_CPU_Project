`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 08:08:48 PM
// Design Name: 
// Module Name: IF_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_top(
        //pipeline control signals
        input logic clk, nrst, flush, stall,
        input logic [31:0] PC_next,
        output logic [31:0] instr,
        output logic [31:0] PC_out, //to decode pipeline reg

        //branch mem signals
        output logic predicted_jump, //from ex stage
        input logic [4:0] MUX_en, //from decode stage
        input logic pc_switch, //from ex stage
        input logic [31:0] PC_Ex, //from ex stage
        input logic [31:0] target, //from ex_stage

        //instruction cache signals
        input logic [31:0] ID_addr, //PC from decode stage
        input logic [31:0] start_data,
        input logic [31:0] start_addr,
        input logic start_done,
        input logic ddr_rd_done,
        input logic [511:0] ddr_data_in,
        output logic ddr_rd_miss,
        output logic [31:0] ddr_addr,
        output logic stall_out
    );

    logic [1:0] bht;
    logic [31:0] branch_addr;

    assign instr = catch_this.instr;
    
    program_counter gaming_pc(
        .PC_in(PC_out),
        .pred_j(predicted_jump),
        .*
    );

    Branch_mem tree_trunk(
        .pc_in(PC_out),
        .pc_d(PC_Ex),
        .*
    );

    Ins_cache catch_this(
        .PC_in(PC_out),
        .*
    );

endmodule
