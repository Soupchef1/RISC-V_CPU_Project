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
    input logic FU_stall,
    input logic [31:0] pc_next,

    output logic flush,
    output logic stall_out,
    output logic [31:0] pc_corrected,

    input logic start_done,

    // pipelined control signals
    output ctrl_signal_t decode_ctrl,
    (* max_fanout = 16, dont_touch = "true" *) output ctrl_signal_t ex_ctrl,
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

    logic cache_stall;

    logic [31:0] pc_next_reg;
    (* max_fanout = 20*) logic flush_reg, flush_next;

    always_ff @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            decode_ctrl.predicted_jump <= LOW;
            ex_ctrl <= '0; //TODO make sure all zeroes is default
            mem_ctrl <= '0;
            write_back_ctrl <= LOW;

            flush_reg <= LOW;
            pc_next_reg <= '0;
        end else begin
            //flush needs to clear ex and decode
            //cache_stall stalls all
            //FU_stall stalls ex, decode, fetch; flushes mem

            //priority order: 1. flush, 2. cache_stall, FU_stall
            if (flush) begin
                ex_ctrl <= '0;
                decode_ctrl.predicted_jump <= LOW;
            end else if (!cache_stall & !FU_stall) begin
                ex_ctrl <= decode_ctrl;
                decode_ctrl.predicted_jump <= predicted_jump_fetch;
            end
            
            if(flush | (!cache_stall & FU_stall)) begin
                mem_ctrl <= '0;
            end else if(!cache_stall) begin
                mem_ctrl <= ex_ctrl;
            end



            if (!cache_stall) begin
                write_back_ctrl <= mem_ctrl.write_back;
            end

            if(!cache_stall & !FU_stall & !flush) begin
                flush_reg <= flush_next;
                pc_next_reg <= pc_next;
            end else begin
                flush_reg <= LOW;
            end
        end //registers automatically retain value, no need to specify
    end

    always_comb begin
        flush_next = pc_switch ^ decode_ctrl.predicted_jump;
        flush = (start_done) ? flush_reg : HIGH;
        pc_corrected = pc_next_reg;

        stall_out = stall_inst || stall_data_cache;
        cache_stall = stall_inst || stall_data_cache;

    end


endmodule

