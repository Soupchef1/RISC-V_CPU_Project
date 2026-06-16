`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2026 08:01:40 PM
// Design Name: 
// Module Name: Data_cache
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


module Data_cache(

    input logic clk, nrst,

    input logic [31:0] EX_addr,
    input logic [31:0] EX_data,
    input logic [1:0] EX_mem_bytes, //#bytes to write: 00 for 0 bytes, 01 for 1 byte, 10 for 2 bytes, 11 for 4 bytes;
    input logic EX_read_en,
    input logic EX_write_en,

    input logic [31:0] MA_addr,
    input logic [31:0] MA_data_in,
    output logic [31:0] MA_data_out,

    input logic ddr_rd_done,
    input logic [511:0] ddr_data_in,
    output logic ddr_rd_miss,
    output logic ddr_wr_miss,
    output logic [511:0] ddr_data_out,
    output logic [31:0] ddr_addr,
    output logic ddr_dirty,
    output logic is_video_data,

    output logic stall_out;
    );
    
    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena, enb;
    logic [66:0] wea;
    logic [8:0] addra, addrb;
    logic [535:0] dina, doutb;

    logic [23:0] tag_in ; //tag being written to BRAM
    logic [23:0] tag_out; //tag being read from BRAM
    logic [511:0] data_in; //data written to BRAM
    logic [511:0] data_out; //data read from BRAM
    logic write_en, read_en;
    logic [8:0] addr;

    logic [31:0] MA_addr;

    logic [511:0] regular_data_in;
    logic [66:0] regular_wea;

    assign enb = HIGH;
    assign dina = {tag_in, data_in};
    assign data_out = doutb[511:0];
    assign tag_out = doutb[535:512];
    assign addrb = addr;
    assign addra = addr;
    
    // TODO: make sure to implement these 
    assign data_in =
    assign wea =
    assign ena = 
    assign addr = //during regular operation, addr is EX_addr. during cache miss, addr is MA_addr

    blk_mem_gen_0_sv freak_bob (
        .clka(clk), // input wire clka
        .ena(ena), // input wire ena
        .wea(wea), // input wire [66:0] wea
        .addra(addra), // input wire [8:0] addra
        .dina(dina), // input wire [535:0] dina
        .clkb(clk), // input wire clkb
        .enb(enb), // input wire enb
        .addrb(addrb), // input wire [8:0] addrb
        .doutb(doutb) // output wire [535:0] doutb
    );

    //make sure to change so that signals comply when cache miss
    always_comb begin

        //reading combinational logic
        MA_data_out = data_out[MA_addr[5:2] * 32 +: 32];  //picks out right word

        //writing combinational logic
        tag_in = {5'b0, 1'b1, 1'b1, EX_addr[31:15]};

        regular_data_in = '0;
        regular_wea = '0;
        if(EX_write_en) begin
            case(EX_mem_bytes):
                2'b00: begin 
                    regular_wea = '0;
                    regular_data_in = '0;
                end

                2'b01: begin
                    regular_wea[EX_addr[5:0]] = HIGH;
                    regular_data_in = {64{EX_data[7:0]}}; // fills data_in with 64 of the same byte
                end
                
                2'b10: begin
                    regular_wea[{EX_addr[5:1], 1'b0} +: 2] = 2'b11;
                    regular_data_in = {32{EX_data[15:0]}};
                end

                2'b11: begin
                    regular_wea[{EX_addr[5:2], 2'b00} +: 4] = 4'b1111;
                    regular_data_in = {16{EX_data}};
                end
            endcase
        end
    end

    //cache miss logic
    logic cache_miss;

    typedef enum logic { 
        IDLE,
        PAUSE
    } state_t;

    state_t state, next_state;

    //TODO: write code for cache miss

    //data in pseudo code
    // if regular:
    //     just make data_in whats above (lines 86-120)
    // if drr_rd_done:
    //     make data_in data from ddr with data from lines 86-120 inserted.

    // if cache miss:
    //     make ena LOW until ready to write data;
    // otherwise:
    //     make ena what EX_read_en is

endmodule
