`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 07:51:40 PM
// Design Name: 
// Module Name: EX_top
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

module EX_top (

    //ports related to ALU
    input logic [31:0] pc,           //s
    input logic [31:0] rs1_data,     //s
    input logic [31:0] rs2_data,     //s
    input logic [4:0] rd_in,
    input logic [31:0] imm,          //s
    input logic [4:0] MUX_en,        //c
    input logic [3:0] ALU_op,        //c
    output logic [31:0] ALU_out,   
    output logic [31:0] target,
    output logic [31:0] pc_next,
    output logic pc_switch,
    output logic [4:0] rd_out,

    //ports for data forwarding
    input logic [4:0] rs1_addr, rs2_addr, MA_rd, WB_rd,
    input logic [31:0] WB_data,
    input logic MA_write_back, WB_write_back,
    output logic FU_stall,

    //stage outputs
    output logic [31:0] PC_D,
    output logic [31:0] rs2_data_o,
    output logic [31:0] memory_addr,

    //stage inputs
    input logic flush_en,            //c
    input logic clk,                 //c
    input logic nrst,                //c
    input logic stall_en             //c

);

    //internal ports
    logic [31:0] pc_int;          //s
    logic [31:0] rs1_data_int;    //s
    logic [31:0] rs2_data_int;     //s
    logic [4:0] rd_int;
    logic [31:0] imm_int;          //s
    logic [31:0] rs1_ALU;
    logic [31:0] rs2_ALU;
    logic [4:0] rs1_addr_reg, rs2_addr_reg;

    assign rs2_data_o = rs2_ALU;
    assign rd_out = rd_int;
    assign PC_D = pc_int;
    assign memory_addr = {6'b0, rs1_ALU[25:0] + imm_int[25:0]};

    //pipeline based signals
    always_ff @(posedge clk, negedge nrst) begin

        if (!nrst) begin
            //idk what goes here
            pc_int <=       '0;
            rs1_data_int <= '0;
            rs2_data_int <= '0;
            imm_int <=      '0;
            rd_int <=       '0;
            rs1_addr_reg <= '0;
            rs2_addr_reg <= '0;
        end else if (flush_en) begin
            pc_int <=           '0;
            rs1_data_int <=     '0;
            rs2_data_int <=     '0;
            imm_int <=          '0;
            rd_int <=           '0;
            rs1_addr_reg <= '0;
            rs2_addr_reg <= '0;
        end else if (!(stall_en | FU_stall)) begin
            pc_int       <= pc;
            rs1_data_int <= rs1_data;
            rs2_data_int <= rs2_data;
            imm_int      <= imm;
            rd_int       <= rd_in;
            rs1_addr_reg <= rs1_addr;
            rs2_addr_reg <= rs2_addr;
        end
    end

    ALU ALU_exCore (
        .pc(pc_int),
        .rs1_data(rs1_ALU),
        .rs2_data(rs2_ALU),
        .imm(imm_int),
        .MUX_en(MUX_en),
        .ALU_op(ALU_op),
        .ALU_out(ALU_out),
        .target(target),
        .pc_next(pc_next),
        .pc_switch(pc_switch)
    );

    forwardingUnit forward (
        .rs1_addr(rs1_addr_reg),
        .rs2_addr(rs2_addr_reg),
        .rs1_data(rs1_data_int),
        .rs2_data(rs2_data_int),
        .rs1(rs1_ALU),
        .rs2(rs2_ALU),
        .stall(stall_en),
        .*
    );

endmodule