`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 07:49:32 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input logic [31:0] instr,

    output logic [4:0] rs1, rs2, rd,
    output logic [2:0] func3,
    output logic [6:0] func7,
    output logic [4:0] opcode,
    output logic [31:0] imm
    );

    always_comb begin
        casez(instr[6:0])
            //R-Type
            7'b0110011: begin
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                rd = instr[11:7];
                func3 = instr[14:12];
                func7 = instr[31:25];
                opcode = instr[6:2];
                imm = '0;
            end

            //I-Type
            7'b0010011, 7'b0000011, 7'b1100111: begin
                rs1 = instr[19:15];
                rs2 = '0;
                rd = instr[11:7];
                func3 = instr[14:12];
                func7 = instr[31:25];
                opcode = instr[6:2];
                imm = {{20{instr[31]}}, instr[31:20]};
            end

            //S-Type
            7'b0100011: begin
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                rd = '0;
                func3 = instr[14:12];
                func7 = '0;
                opcode = instr[6:2];
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            //B-Type
            7'b1100011: begin
                rs1 = instr[19:15];
                rs2 = instr[24:20];
                rd = '0;
                func3 = instr[14:12];
                func7 = '0;
                opcode = instr[6:2];
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end

            //U-Type
            7'b0110111, 7'b0010111: begin
                rs1 = '0;
                rs2 = '0;
                rd = instr[11:7];
                func3 = '0;
                func7 = '0;
                opcode = instr[6:2];
                imm = {instr[31:12], 12'b0};
            end

            //J-Type
            7'b1101111: begin
                rs1 = '0;
                rs2 = '0;
                rd = instr[11:7];
                func3 = '0;
                func7 = '0;
                opcode = instr[6:2];
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            end

            //other
            default: begin
                rs1 = '0;
                rs2 = '0;
                rd = '0;
                func3 = '0;
                func7 = '0;
                opcode = '0;
                imm = '0;
            end
        endcase
    end
endmodule
