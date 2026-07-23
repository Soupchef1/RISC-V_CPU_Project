`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2026 04:01:49 PM
// Design Name: 
// Module Name: ID_top
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


module ID_top( 
        //global signals
        input logic clk, nrst,

        //decode signals 
        input logic [31:0] PC_in,
        input logic [31:0] instr_in,
        output logic [31:0] PC_out,
        output logic [31:0] rs1_data, rs2_data, imm,
        output logic [4:0] rd,

        //write back signals
        input logic wb_en,
        input logic [4:0] wb_addr,
        input logic [31:0] wb_data,

        //controller signals
        input logic flush_en, stall_en,   
        output logic [2:0] func3,
        output logic [6:0] func7,
        output logic [4:0] rs1_addr, rs2_addr,
        output logic [4:0] opcode
    );

    logic [31:0] instr_use;
    logic [31:0] PC_reg;

    assign instr_use = (flush_en) ? '0 : instr_in;
    assign PC_out = PC_reg;



    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst | flush_en) begin
            PC_reg <= '0;
        end else if(stall_en) begin
            PC_reg <= PC_reg;
        end else begin
            PC_reg <= PC_in;
        end
    end

    Register_file rf_inst (
        .clk(clk),
        .nrst(nrst),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .write_addr(wb_addr),
        .write_data(wb_data),
        .rd_en(1'b1),
        .w_en(wb_en),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    decoder decode_inst (
        .instr(instr_use),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rd(rd),
        .func3(func3),
        .func7(func7),
        .opcode(opcode),
        .imm(imm)
    );
endmodule
