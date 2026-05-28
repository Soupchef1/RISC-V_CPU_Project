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
    output logic [31:0] ALU_out,
    output logic [31:0] target,
    output logic [31:0] pc_next

);

    logic [31:0] op_a;
    logic [31:0] op_b;
    logic [31:0] result;
    logic [31:0] op_c;
    logic [31:0] op_d;
    logic [31:0] b_result;
    
    assign op_a = (MUX_en[1] == 1'b0)? rs1_data : pc;
    assign op_b = (MUX_en[0] == 1'b0)? rs2_data : imm;
    assign op_c = (MUX_en[2] == 1'b0)? pc : rs1_data;
    assign op_d = imm;
        
    always_comb begin
    
        b_result = op_c + op_d;
        
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
            4'd10: result = (op_a == op_b)? 32'd1 : 32'd0;
            4'd11: result = (op_a != op_b)? 32'd1 : 32'd0;
            4'd12: result = ($signed(op_a) >= $signed(op_b))? 32'd1 : 32'd0;
            4'd13: result = (op_a >= op_b)? 32'd1 : 32'd0;
            default: result = 32'b0;
        endcase
        
    end

    assign ALU_out = (MUX_en[4] == 1'b0)? result : (pc + 32'd4);
    assign pc_next = ((MUX_en[3] == 1'b1) & (result[0] == 1'b1))? b_result : (pc + 32'd4);
    assign target = b_result;

endmodule
