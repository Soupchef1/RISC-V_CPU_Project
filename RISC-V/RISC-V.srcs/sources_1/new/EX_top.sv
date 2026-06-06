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
    input logic [31:0] imm,          //s
    input logic [4:0] MUX_en,        //c
    input logic [3:0] ALU_op,        //c
    output logic [31:0] ALU_out,    
    output logic [31:0] target,
    output logic [31:0] pc_next,
    output logic pc_switch,

    //ports for data forwarding
    input logic [3:0] FUmux,         //c
    input logic [31:0] ALU_outex,    //c
    input logic [31:0] ALU_outmem,   //c

    //stage outputs
    output logic [31:0] PC_D,
    output logic [31:0] rs2_data_o,

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
    logic [31:0] imm_int;          //s
    logic [1:0] pipe_cont;
    logic [31:0] rs1_ALU;
    logic [31:0] rs2_ALU;

    assign pipe_cont = {flush_en, stall_en};

    //pipeline based signals
    always_ff @(posedge clk or negedge nrst) begin

        if (!nrst) begin
            //idk what goes here
            pc_int <= 32'b0;
            rs1_data_int <= 32'b0;
            rs2_data_int <= 32'b0;
            imm_int <= 32'b0;
        end

        else begin

            case (pipe_cont)     //this could be all wrong
                
                default: begin 
                    //do nothing --> full stall
                    pc_int <= pc_int;
                    rs1_data_int <= rs1_data_int;
                    rs2_data_int <= rs2_data_int;
                    imm_int <= imm_int;

                end

                2'b00: begin //normal operations
                    pc_int <= pc;
                    rs1_data_int <= rs1_data;
                    rs2_data_int <= rs2_data;
                    imm_int <= imm;
                end

                2'b11: begin //stall and flush
                    pc_int <= 32'b0;
                    rs1_data_int <= 32'b0;
                    rs2_data_int <= 32'b0;
                    imm_int <= 32'b0;
                end

                2'b10: begin //normal flush
                    pc_int <= 32'b0;
                    rs1_data_int <= 32'b0;
                    rs2_data_int <= 32'b0;
                    imm_int <= 32'b0;
                end

            endcase
        end
    end


    always_comb begin

        PC_D = pc_int;

        case (FUmux) 

            default: begin
                rs1_ALU = rs1_data_int;
                rs2_ALU = rs2_data_int;
            end
            4'd1: begin
                rs1_ALU = rs1_data_int;
                rs2_ALU = ALU_outex;
            end
            4'd2: begin
                rs1_ALU = rs1_data_int;
                rs2_ALU = ALU_outmem;
            end
            4'd3: begin
                rs1_ALU = ALU_outex;
                rs2_ALU = rs2_data_int;
            end
            4'd4: begin
                rs1_ALU = ALU_outex;
                rs2_ALU = ALU_outex;
            end
            4'd5: begin
                rs1_ALU = ALU_outex;
                rs2_ALU = ALU_outmem;
            end
            4'd6: begin
                rs1_ALU = ALU_outmem;
                rs2_ALU = rs2_data_int;
            end
            4'd7: begin
                rs1_ALU = ALU_outmem;
                rs2_ALU = ALU_outex;
            end
            4'd8: begin
                rs1_ALU = ALU_outmem;
                rs2_ALU = ALU_outmem;
            end

        endcase

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

endmodule