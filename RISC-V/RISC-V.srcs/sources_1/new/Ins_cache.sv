`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2026 02:51:19 PM
// Design Name: 
// Module Name: Ins_cache
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


module Ins_cache(
    input logic clk, nrst,

    input logic [31:0] PC_in, //addr in instruction fetch
    output logic [31:0] instr,

    input logic [31:0] ID_addr, //addr in instruction decode

    //startup signals
    input logic [31:0] start_data, 
    input logic [31:0] start_addr,
    input logic start_done,

    //mem ctrl signals
    input logic ddr_rd_done,
    input logic [511:0] ddr_data_in,
    output logic ddr_rd_miss,
    output logic [31:0] ddr_addr,

    //controller signals
    output logic stall_out
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena, enb;
    logic [66:0] wea;
    logic [8:0] addra, addrb;
    logic [535:0] dina, doutb;

    logic [511:0] data_in, data_out;
    logic [23:0] tagline_in, tagline_out;

    // cache miss signals
    typedef enum logic [1:0]{
        STARTUP, 
        IDLE,
        PAUSE
    } state_t;

    state_t state, next_state;

    logic rd_miss;
    
    assign ddr_rd_miss = rd_miss | !tagline_out[18];

    assign dina = {tagline_in, data_in};
    assign data_out = doutb[511:0];
    assign tagline_out = doutb[535:512];

    blk_mem_gen_0 Ben_hella_gay (
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

    //logic comb
    always_comb begin
        ena = LOW;
        enb = LOW;
        wea = '0;
        addra = '0;
        addrb = '0;
        data_in = '0;
        tagline_in = '0;
        instr = '0;

        case(state)
            //during start up, specify which word address and data to write to
            STARTUP: begin
                ena = HIGH;
                wea[{start_addr[5:2], 2'b00} +: 4] = 4'b1111;
                wea[66:64] = 3'b111;
                addra = start_addr[14:6];
                data_in = {16{start_data}};
                tagline_in = {5'b0, 1'b1, 1'b0, start_addr[31:15]}; //set dirty LOW (unused) and valid HIGH
            end
            
            IDLE: begin
                enb = HIGH;
                addrb = PC_in[14:6];
                instr = data_out[ID_addr[5:2] * 32 +: 32];
            end 

            PAUSE: begin
                ena = (ddr_rd_done) ? HIGH : LOW;
                wea = '1;
                addra = ID_addr[14:6];
                data_in = ddr_data_in;
                tagline_in = {5'b0, 1'b1, 1'b0, ID_addr[31:15]}; //set dirty LOW (unused) and valid HIGH

                enb = HIGH;
                addrb = ID_addr[14:6];

                instr = ddr_data_in[ID_addr[5:2] * 32 +: 32];
            end
        endcase

        //cache miss logic
        ddr_addr = ID_addr;
        rd_miss = tagline_out[16:0] != ID_addr[31:15];
    end

    //state machine comb
    always_comb begin
        next_state = state;
        stall_out = LOW;

        case(state)
            STARTUP: begin
                next_state = (start_done) ? IDLE : STARTUP;
            end
            IDLE: begin
                next_state = (rd_miss) ? PAUSE : IDLE;
                stall_out = (rd_miss) ? HIGH : LOW;
            end
            PAUSE: begin
                next_state = (ddr_rd_done) ? IDLE : PAUSE;
                stall_out = HIGH;
            end
        endcase
    end

    //sequential
    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= STARTUP;
        end else begin
            state <= next_state;
        end
    end

endmodule