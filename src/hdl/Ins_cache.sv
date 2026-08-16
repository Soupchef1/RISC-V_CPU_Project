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
    output logic [31:0] instr_out,

    input logic [31:0] ID_addr, //addr in instruction decode

    //startup signals
    input logic [31:0] start_data, 
    input logic [31:0] start_addr,
    input logic start_done, start_valid, start_write_en,

    //mem ctrl signals
    input logic ddr_rd_done,
    input logic [511:0] ddr_data_in,
    output logic ddr_rd_miss,
    output logic [31:0] ddr_addr,

    //controller signals
    input logic stall,
    output logic stall_out
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena;
    logic [66:0] wea;
    logic [8:0] addra;
    logic [535:0] dina, douta;

    logic [511:0] data_in, data_out;
    logic [23:0] tagline_in, tagline_out;

    (* max_fanout = 30 *) logic [31:0] stall_instr_reg; //register to store correct data for output when stall goes low
    logic [31:0] next_stall_instr_reg; 
    logic [31:0] instr;

    // cache miss signals
    typedef enum logic [1:0]{
        STARTUP, 
        IDLE,
        MISS,
        RETURN
    } state_t;

    state_t state, next_state;

    logic rd_miss;
    
    assign ddr_rd_miss = (state == IDLE) && (rd_miss | !tagline_out[18]);

    assign dina = {tagline_in, data_in};
    assign data_out = douta[511:0];
    assign tagline_out = douta[535:512];

    blk_mem_gen_2_sv Ben_not_gay (
        .clka(clk), // input wire clka
        .ena(ena), // input wire ena
        .wea(wea), // input wire [66:0] wea
        .addra(addra), // input wire [8:0] addra
        .dina(dina), // input wire [535:0] dina
        .douta(douta) // output wire [535:0] douta
    );

    //logic comb
    always_comb begin
        ena = HIGH;
        wea = '0;
        addra = '0;
        data_in = '0;
        tagline_in = '0;
        instr = '0;

        case(state)
            //during start up, specify which word address and data to write to
            STARTUP: begin
                if(start_write_en & (start_addr[31:15] == 17'd0)) begin
                    wea[{start_addr[5:2], 2'b00} +: 4] = 4'b1111;
                    wea[66:64] = 3'b111;

                    addra = start_addr[14:6];
                    data_in = {16{start_data}};
                    tagline_in = {5'b0, start_valid, 1'b0, 17'd0}; //set dirty LOW (unused) and valid HIGH
                end
                
                instr_out = instr;
            end
            
            IDLE: begin
                addra = PC_in[14:6];

                instr = data_out[ID_addr[5:2] * 32 +: 32];

                instr_out = instr;
            end 

            MISS: begin
                ena = (ddr_rd_done) ? HIGH : LOW;
                wea = '1;
                addra = ID_addr[14:6];
                data_in = ddr_data_in;
                tagline_in = {5'b0, 1'b1, 1'b0, ID_addr[31:15]}; //set dirty LOW (unused) and valid HIGH

                instr = ddr_data_in[ID_addr[5:2] * 32 +: 32];

                instr_out = instr;
            end

            RETURN: begin
                addra = PC_in[14:6];

                instr = data_out[ID_addr[5:2] * 32 +: 32];

                instr_out = stall_instr_reg;
            end
            
            default: begin
                ena = LOW;
                wea = '0;
                addra = '0;
                data_in = '0;
                tagline_in = '0;
                instr = '0;
                instr_out = instr;
            end
        endcase

        //cache miss logic
        ddr_addr = {ID_addr[31:6], 6'b0}; //TODO: need to align with 512, aka concatenate ID_addr
        rd_miss = tagline_out[16:0] != ID_addr[31:15];
    end

    //state machine comb
    always_comb begin
        next_state = state;
        stall_out = LOW;
        next_stall_instr_reg = stall_instr_reg;

        case(state)
            STARTUP: begin
                next_state = (start_done) ? IDLE : STARTUP;
            end
            IDLE: begin
                if(ddr_rd_miss) begin
                    next_state = MISS;
                    stall_out = HIGH;
                end else if (stall) begin
                    next_state = RETURN;
                end

                next_stall_instr_reg = instr;
            end
            MISS: begin
                next_state = (ddr_rd_done) ? RETURN : MISS;
                stall_out = HIGH;

                next_stall_instr_reg = instr;
            end
            RETURN: begin
                next_state = (stall) ? RETURN : IDLE;
                stall_out = LOW;

                next_stall_instr_reg = stall_instr_reg;
            end
            default: begin
                next_state = IDLE;
                stall_out = LOW;
                next_stall_instr_reg = stall_instr_reg;
            end
        endcase
    end

    //sequential
    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= STARTUP;
            stall_instr_reg <= '0;
        end else begin
            state <= next_state;
            stall_instr_reg <= next_stall_instr_reg;
        end
    end

endmodule