`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: ben li and ryan karami
// 
// Create Date: 06/18/2026 11:49:00 PM
// Design Name: memory top
// Module Name: MEM_TOP
// Project Name: GOON-PU
// Target Devices: ARTY s7-25
// Tool Versions: 
// Description: light work baby!
// 
// Dependencies: brain 
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments: trip asleep
// 
//////////////////////////////////////////////////////////////////////////////////


module MEM_TOP(
    
    input logic clk, nrst,

    input logic [4:0] EX_rd,
    input logic [31:0] EX_addr,
    input logic [31:0] EX_data,
    input logic [1:0] EX_mem_bytes, MA_mem_bytes, //#bytes to write: 00 for 0 bytes, 01 for 1 byte, 10 for 2 bytes, 11 for 4 bytes;
    input logic mem_zero_extend,
    
    //controller signals
    input logic EX_rd_en, EX_wr_en, MA_rd_en, MA_wr_en,
    output logic stall_out,

    //mem controller signals
    input logic ddr_rd_done,
    input logic [511:0] ddr_data_in,
    output logic ddr_rd_miss,
    output logic ddr_wr_miss,
    output logic [511:0] ddr_data_out,
    output logic [31:0] ddr_addr,
    output logic ddr_dirty,
    output logic is_video_data,

    //controller
    input logic flush, stall,

    //to write back
    output logic [31:0] MUX_data_out,
    output logic [4:0] mem_rd,

    //startup
    input logic [31:0] start_addr,
    input logic start_done
    );

    logic [31:0] MA_addr;  //same as ALU_outex
    logic [31:0] CACHE_data_out;
    logic [31:0] sign_extend_data;

    Data_cache Gary (
        .clk(clk),
        .nrst(nrst),
        .EX_addr(EX_addr),
        .EX_data(EX_data),
        .EX_mem_bytes(EX_mem_bytes),
        .EX_read_en(EX_rd_en),
        .EX_write_en(EX_wr_en),
        .MA_addr(MA_addr),
        .MA_read_en(MA_rd_en), 
        .MA_write_en(MA_wr_en),
        .MA_data_out(CACHE_data_out),
        .ddr_rd_done(ddr_rd_done),
        .ddr_data_in(ddr_data_in),
        .ddr_rd_miss(ddr_rd_miss),
        .ddr_wr_miss(ddr_wr_miss),
        .ddr_data_out(ddr_data_out),
        .ddr_addr(ddr_addr),
        .ddr_dirty(ddr_dirty),
        .is_video_data(is_video_data),
        .stall_out(stall_out),
        .start_addr(start_addr),
        .start_done(start_done)
    );
    

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst | flush) begin
            MA_addr <= '0;
            mem_rd <= '0;
        end else if (stall) begin
            MA_addr <= MA_addr;
            mem_rd <= mem_rd;
        end
        else begin
            MA_addr <= EX_addr;
            mem_rd <= EX_rd;
        end
    end

    always_comb begin
        //based on last 2 bits of MA_addr, make sure to pick the write byte to sign entend
        case(MA_mem_bytes)
            2'b00: sign_extend_data = CACHE_data_out;
            2'b01: sign_extend_data = (mem_zero_extend) ? {24'b0, CACHE_data_out[MA_addr[1:0] * 8 +: 8]} : {{24{CACHE_data_out[7]}}, CACHE_data_out[MA_addr[1:0] * 8 +: 8]};
            2'b10: sign_extend_data = (mem_zero_extend) ? {16'b0, CACHE_data_out[MA_addr[1] * 16 +: 16]} : {{16{CACHE_data_out[15]}}, CACHE_data_out[MA_addr[1] * 16 +: 16]};
            2'b11: sign_extend_data = CACHE_data_out;
        endcase

        MUX_data_out = (MA_rd_en) ? sign_extend_data : MA_addr;
    end
    
endmodule
