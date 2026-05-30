`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 06:12:22 PM
// Design Name: 
// Module Name: signal_generator
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


module signal_generator(
        input logic [4:0] opcode,
        input logic [2:0] func3,
        input logic [6:0] func7,

        output logic [4:0] MUX_en,
        output logic [3:0] ALU_op,
        output logic mem_write, mem_read, write_back,
        output logic [1:0] mem_bytes, //00: no bytes, 01: 1 byte, 10: 2 bytes, 11: 4 bytes
        output logic mem_zero_extend
    );

    localparam LOW = 1'b0;
    localparam HIGH = 1'b1;

    logic [3:0] ALU_math, ALU_comp;
    logic [1:0] mem_bytes_temp;
    logic mem_zero_extend_temp;

    typedef enum logic [1:0] {
        MATH,
        COMPARE,
        MEMORY,
        NONE
    } func3_t;

    func3_t func3_type;

    always_comb begin
        casez(opcode) 
            //R-Type
            5'b01100: begin
                MUX_en = 5'b00000;
                func3_type = MATH;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
            end
            
            //I-Type rf
            5'b00100: begin
                MUX_en = 5'b00001;
                func3_type = MATH;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
            end
            
            //I-Type memory
            5'b00000: begin
                MUX_en = 5'b00001;
                func3_type = MEMORY;
                mem_write = LOW;
                mem_read = HIGH;
                
                write_back = HIGH;
            end

            //S-Type
            5'b01000: begin
                MUX_en = 5'b00001;
                func3_type = MEMORY;
                mem_write = HIGH;
                mem_read = LOW;
                write_back = HIGH;
            end

            //B-Type
            5'b11000: begin
                MUX_en = 5'b01001;
                func3_type = COMPARE;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
            end
            
            //jal
            5'b11011: begin
                MUX_en = 5'b11000;
                mem_write = LOW;
                mem_read = LOW;
                mem_bytes = '0;
                mem_zero_extend = LOW;
                write_back = HIGH;
            end

            //jalr
            5'b11001: begin
                MUX_en = 5'b11100;
                func3_type = NONE;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
            end

            //lui
            5'b01101: begin
                MUX_en = 5'b00001;
                func3_type = NONE;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
                
            end

            //auipc
            5'b00101: begin
                MUX_en = 5'b00011;
                func3_type = NONE;
                mem_write = LOW;
                mem_read = LOW;
                write_back = HIGH;
            end

            default: begin
                MUX_en = '0;
                ALU_op = '0;
                mem_write = '0;
                write_back = '0;
            end
        endcase

    end

    always_comb begin
        casez(func3)
            3'h0: begin
                mem_bytes_temp = 2'd1;
                mem_zero_extend_temp = LOW;
            end

            3'h1: begin
                mem_bytes_temp = 2'd2;
                mem_zero_extend_temp = LOW;
            end

            3'h2: begin
                mem_bytes_temp = 2'd3;
                mem_zero_extend_temp = LOW;
            end

            3'h4: begin
                mem_bytes_temp = 2'd1;
                mem_zero_extend_temp = HIGH;
            end

            3'h5: begin
                mem_bytes_temp = 2'd2;
                mem_zero_extend_temp = HIGH;
            end

            default: begin
                mem_bytes_temp = '0;
                mem_zero_extend_temp = LOW;
            end
        endcase

        casez(func3)
            3'h0: ALU_math = (func7 == 7'h2) ? 4'd2 : 4'd1;
            3'h4: ALU_math = 4'd2;
            3'h6: ALU_math = 4'd3;
            3'h7: ALU_math = 4'd4;
            3'h1: ALU_math = 4'd5;
            3'h5: ALU_math = (func7 == 7'h2) ? 4'd7 : 4'd6;
            3'h2: ALU_math = 4'd8;
            3'h3: ALU_math = 4'd9;
        endcase

        casez(func3)
            3'h0: ALU_comp = 4'd10;
            3'h1: ALU_comp = 4'd11;
            3'h4: ALU_comp = 4'd8;
            3'd5: ALU_comp = 4'd12;
            3'd6: ALU_comp = 4'd9;
            3'd7: ALU_comp = 4'd13;
        endcase

        casez(func3_type)
            MATH: begin
                ALU_op = ALU_math;
                mem_bytes = '0;
                mem_zero_extend = LOW;
            end
            COMPARE: begin
                ALU_op = ALU_comp;
                mem_bytes = '0;
                mem_zero_extend = LOW;
            end
            MEMORY: begin
                ALU_op = 4'h1;
                mem_bytes = mem_bytes_temp;
                mem_zero_extend = mem_zero_extend_temp;
            end

            NONE: begin
                ALU_op = 4'h1;
                mem_bytes = '0;
                mem_zero_extend = LOW;
            end
        endcase
    end

endmodule
