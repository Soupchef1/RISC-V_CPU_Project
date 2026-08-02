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
} alu_op_t;

module ALU(

    input logic [31:0] pc,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,
    input logic [4:0] MUX_en,
    input alu_op_t ALU_op,
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
    localparam logic LOW = 1'b0;
    localparam logic HIGH = 1'b1;
    localparam int INPUT_A_SEL = 1;
    localparam int INPUT_B_SEL = 0;
    localparam int BRANCH_ADDER = 2;
    localparam int BRANCH_EN = 3;
    localparam int STORE_JUMP = 4;
    localparam logic [31:0] WORD_LENGTH = 32'd4;

    assign op_a = (MUX_en[INPUT_A_SEL] == LOW)? rs1_data : pc;
    assign op_b = (MUX_en[INPUT_B_SEL] == LOW)? rs2_data : imm;
    assign op_c = (MUX_en[BRANCH_ADDER] == LOW)? pc : rs1_data;
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
    
    assign ALU_out = (MUX_en[STORE_JUMP] == LOW)? result : (pc + WORD_LENGTH);
    assign pc_next = (MUX_en[STORE_JUMP] | (MUX_en[BRANCH_EN] == HIGH) & (result[0] == HIGH))? b_result : (pc + WORD_LENGTH);
    assign target = b_result;
    assign pc_switch = (MUX_en[STORE_JUMP] | (MUX_en[BRANCH_EN] == HIGH) & (result[0] == HIGH))? HIGH : LOW;

endmodule
