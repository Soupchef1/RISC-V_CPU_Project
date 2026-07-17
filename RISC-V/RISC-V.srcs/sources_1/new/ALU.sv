`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 10:21:09 PM
// Design Name: 
// Module Name: ALU
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
typedef enum logic[3:0]{
    ADD                          = 4'd0,
    SUB                          = 4'd1,
    XOR                          = 4'd2,
    OR                           = 4'd3,
    AND                          = 4'd4,
    SHIFT_L_LOGIC                = 4'd5,
    SHIFT_R_LOGIC                = 4'd6,
    SHIFT_R_ARITH                = 4'd7,
    IS_LESS_THAN_SIGNED          = 4'd8,
    IS_LESS_THAN_UNSIGNED        = 4'd9,
    IS_EQUAL                     = 4'd10,
    IS_NOT_EQUAL                 = 4'd11,
    IS_GREATER_OR_EQUAL_SIGNED   = 4'd12,
    IS_GREATER_OR_EQUAL_UNSIGNED = 4'd13
} ALU_op_t;

module ALU(

    input logic [31:0] pc,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,
    input logic [4:0] MUX_en,
    input logic [3:0] ALU_op,
    output logic [31:0] ALU_out,
    output logic [31:0] target,
    output logic [31:0] pc_next,
    output logic pc_switch

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
            ADD:                                 result = op_a + op_b;
            SUB:                                 result = op_a - op_b;
            XOR:                                 result = op_a ^ op_b;
            OR:                                  result = op_a | op_b;
            AND:                                 result = op_a & op_b;
            SHIFT_L_LOGIC:                       result = op_a << op_b[4:0];
            SHIFT_R_LOGIC:                       result = op_a >> op_b[4:0];
            SHIFT_R_ARITH:                       result = $signed(op_a) >>> op_b[4:0];
            IS_LESS_THAN_SIGNED:                 result = ($signed(op_a) < $signed(op_b))? 32'd1 : 32'd0;
            IS_LESS_THAN_UNSIGNED:               result = (op_a < op_b)? 32'd1 : 32'd0;
            IS_EQUAL:                            result = (op_a == op_b)? 32'd1 : 32'd0;
            IS_NOT_EQUAL:                        result = (op_a != op_b)? 32'd1 : 32'd0;
            IS_GREATER_OR_EQUAL_SIGNED:          result = ($signed(op_a) >= $signed(op_b))? 32'd1 : 32'd0;
            IS_GREATER_OR_EQUAL_UNSIGNED:        result = (op_a >= op_b)? 32'd1 : 32'd0;
            default:                             result = 32'b0;
        endcase
        
    end
    
    assign ALU_out = (MUX_en[4] == 1'b0)? result : (pc + 32'd4);
    assign pc_next = (MUX_en[4] | (MUX_en[3] == 1'b1) & (result[0] == 1'b1))? b_result : (pc + 32'd4);
    assign target = b_result;
    assign pc_switch = (MUX_en[4] | (MUX_en[3] == 1'b1) & (result[0] == 1'b1))? 1'b1 : 1'b0;

endmodule
