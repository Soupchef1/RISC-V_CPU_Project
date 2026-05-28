`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 10:21:09 PM
// Design Name: 
// Module Name: ALU_core
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


module ALU_core (

    input logic [31:0] pc,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,
    input logic [4:0] MUX_en,
    input logic [3:0] ALU_op,
    output logic [31:0] ALU_out

);

logic [31:0] op_a;
logic [31:0] op_b;

assign op_a = (MUX_en[1] == 0)? rs1_data : pc;
assign op_b = (MUX_en[0] == 0)? rs2_data : imm;

always_comb begin

    case (ALU_op)

        4'd0: ALU_out = op_a + op_b;
        4'd1: ALU_out = op_a - op_b;
        4'd2: ALU_out = op_a ^ op_b;
        4'd3: ALU_out = op_a | op_b;
        4'd4: ALU_out = op_a & op_b;
        4'd5: ALU_out = op_a << op_b;
        4'd6: ALU_out = op_a >> op_b;
        4'd7: ALU_out = $signed(op_a) >>> op_b;
        4'd8: ALU_out = ($signed(op_a) < $signed(op_b))? 32'd1 : 32'd0;
        4'd9: ALU_out = (op_a < op_b)? 32'd1 : 32'd0;
        4'd10: ALU_out = (op_1 == op_b)? 32'd1 : 32'd0;
        4'd11: ALU_out = (op_1 != op_b)? 32'd1 : 32'd0;
        4'd12: ALU_out = ($signed(op_a) >= $signed(op_b))? 32'd1 : 32'd0;
        4'd13: ALU_out = (op_a >= op_b)? 32'd1 : 32'd0;

    endcase

end

endmodule
