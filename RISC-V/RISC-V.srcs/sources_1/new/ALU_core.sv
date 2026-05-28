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
logic [31:0] result;

assign op_a = (MUX_en[1] == 0)? rs1_data : pc;
assign op_b = (MUX_en[0] == 0)? rs2_data : imm;

always_comb begin

    case (ALU_op)

        4'd0: result = op_a + op_b;
        4'd1: result = op_a - op_b;
        4'd2: result = op_a ^ op_b;
        4'd3: result = op_a | op_b;
        4'd4: result = op_a & op_b;
        4'd5: result = op_a << op_b;
        4'd6: result = op_a >> op_b;
        4'd7: result = $signed(op_a) >>> op_b;
        4'd8: result = ($signed(op_a) < $signed(op_b))? 32'd1 : 32'd0;
        4'd9: result = (op_a < op_b)? 32'd1 : 32'd0;
        4'd10: result = (op_1 == op_b)? 32'd1 : 32'd0;
        4'd11: result = (op_1 != op_b)? 32'd1 : 32'd0;
        4'd12: result = ($signed(op_a) >= $signed(op_b))? 32'd1 : 32'd0;
        4'd13: result = (op_a >= op_b)? 32'd1 : 32'd0;

    endcase

end

    assign ALU_out = (MUX_en[4] == 0)? result : (pc + 32'd4);

endmodule
