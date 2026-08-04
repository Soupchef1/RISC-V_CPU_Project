`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2026 05:30:25 PM
// Design Name: 
// Module Name: main_controller
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

localparam logic HIGH = 1'b1;
localparam logic LOW = 1'b0;

import ctrl_signal_pkg::*;

module main_controller(
    input logic clk,
    input logic nrst,

    input logic[4:0] opcode,
    input logic[2:0] func3,
    input logic[6:0] func7,

    input logic predicted_jump_fetch,
    input logic pc_switch,
    input logic stall_inst,
    input logic stall_data_cache,

    output logic flush,
    output logic stall_out,

    // pipelined control signals
    output ctrl_signal_t decode_ctrl,
    output ctrl_signal_t ex_ctrl,
    output ctrl_signal_t mem_ctrl,
    output logic write_back_ctrl //only need write back signal
    );

    signal_generator signal_generator_0 (
        // inputs
        .opcode(opcode),
        .func3(func3),
        .func7(func7),

        // outputs
        .MUX_en(decode_ctrl.MUX_en),
        .ALU_op(decode_ctrl.ALU_op),
        .mem_write(decode_ctrl.mem_write),
        .mem_read(decode_ctrl.mem_read),
        .write_back(decode_ctrl.write_back),
        .mem_bytes(decode_ctrl.mem_bytes),
        .mem_zero_extend(decode_ctrl.mem_zero_extend)
    );

    always_ff @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            decode_ctrl.predicted_jump <= LOW;
            ex_ctrl <= '0; //TODO make sure all zeroes is default
            mem_ctrl <= '0;
            write_back_ctrl <= LOW;
        end

        else if(stall_inst || stall_data_cache) begin
            // do not pipeline controller registers
            decode_ctrl.predicted_jump <= decode_ctrl.predicted_jump;
            ex_ctrl <= (flush) ? '0 : ex_ctrl;
            mem_ctrl <= mem_ctrl;
            write_back_ctrl <= write_back_ctrl;
        end

        else begin
        // pipelining control sigals
            decode_ctrl.predicted_jump <= predicted_jump_fetch;
            ex_ctrl <= (flush) ? '0 : decode_ctrl;
            mem_ctrl <= ex_ctrl;
            write_back_ctrl <= mem_ctrl.write_back;
        end
    end

    always_comb begin
        flush = pc_switch ^ decode_ctrl.predicted_jump;
        stall_out = stall_inst || stall_data_cache;
    end


endmodule

