`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:22:27 PM
// Design Name: 
// Module Name: startup_ctrl
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


module startup_ctrl(
        input logic clk, nrst,

        input logic [31:0] pkt_addr, pkt_data,
        input logic pkt_ready, pkt_finish,

        input logic mig_calib_complete,

        output logic [31:0] data, addr,
        output logic start_done, start_valid, start_write_en,

        input logic axi_ctrl_bvalid
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    typedef enum logic [1:0] { 
        VALID,
        BOOT,
        PAUSE,
        IDLE
    } start_state;

    start_state state, next_state;

    logic [9:0] addr_cnt, next_addr_cnt;

    always_ff @(posedge clk, nrst) begin
        if(!nrst) begin
            state <= VALID;
            addr_cnt <= '0;
        end else begin
            state <= next_state;
            addr_cnt <= next_addr_cnt;
        end
    end

    always_comb begin
        casez(state)
            VALID: begin
                next_addr_cnt = (addr_cnt == 10'd1047) ? addr_cnt : addr_cnt + 10'd1;
                next_state = (addr_cnt == 10'd1047 && mig_calib_complete) ? BOOT : VALID;

                start_done = LOW;
                start_valid = LOW;
                start_write_en = LOW;

                addr = {17'b0, addr_cnt[8:0], 6'b0};
                data = '0;
            end

            BOOT: begin
                next_addr_cnt = 10'd0;
                next_state = (pkt_finish) ? PAUSE : BOOT;

                start_done = LOW;
                start_valid = HIGH;
                start_write_en = pkt_ready;

                addr  = pkt_addr;
                data = pkt_data;
            end

            PAUSE: begin
                next_addr_cnt = '0;
                next_state = (axi_ctrl_bvalid) ? PAUSE : IDLE;

                start_done = LOW;
                start_valid = LOW;
                start_write_en = LOW;

                addr = '0;
                data = '0;
            end

            IDLE: begin
                next_addr_cnt = '0;
                next_state = IDLE;

                start_done = HIGH;
                start_valid = LOW;
                start_write_en = LOW;

                addr = '0;
                data = '0;
            end

            default: begin
                next_addr_cnt = '0;
                next_state = IDLE;

                start_done = LOW;
                start_valid = LOW;
                start_write_en = LOW;

                addr = '0;
                data = '0;                
            end
        endcase
    end

endmodule
