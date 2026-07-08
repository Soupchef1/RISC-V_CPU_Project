`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: Benjamin Li and Ryan Karami
// 
// Create Date: 06/15/2026 08:01:40 PM
// Design Name: Data cache
// Module Name: Data_cache
// Project Name: GOON-PU
// Target Devices: ARTY s7-25
// Tool Versions: idk
// Description: implements cache :)
// 
// Dependencies: brain
// 
// Revision: 50!
// Revision 0.01 - File Created
// Additional Comments:
// Trip faded us
//////////////////////////////////////////////////////////////////////////////////


module Data_cache(

    input logic clk, nrst,

    input logic [31:0] EX_addr,
    input logic [31:0] EX_data,
    input logic [1:0] EX_mem_bytes, //#bytes to write: 00 for 0 bytes, 01 for 1 byte, 10 for 2 bytes, 11 for 4 bytes;
    input logic EX_read_en,
    input logic EX_write_en,

    input logic [31:0] MA_addr,
    input logic [31:0] MA_data_in, //new signal
    input logic MA_read_en, MA_write_en,
    input logic [1:0] MA_mem_bytes, //new signal
    output logic [31:0] MA_data_out,

    input logic ddr_rd_done,
    input logic [511:0] ddr_data_in,
    output logic ddr_rd_miss,
    output logic ddr_wr_miss,
    output logic [511:0] ddr_data_out,
    output logic [31:0] ddr_addr,
    output logic ddr_dirty,
    output logic is_video_data,

    output logic stall_out,

    //startup signals
    input logic [31:0] start_data, 
    input logic [31:0] start_addr,
    input logic start_done

    );
    
    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena, enb;
    logic [66:0] wea;
    logic [8:0] addra, addrb;
    logic [535:0] dina, doutb;

    logic [23:0] tagline_in; //tag being written to BRAM
    logic [23:0] tagline_out; //tag being read from BRAM
    logic [511:0] data_in; //data written to BRAM
    logic [511:0] data_out; //data read from BRAM
    logic write_en, read_en;
    logic [8:0] addr;

    // regular operation signals
    logic [511:0] regular_data_in;
    logic [23:0] regular_tagline_in;
    logic [66:0] regular_wea;

    // cache miss signals
    typedef enum logic [1:0] { 
        STARTUP,
        IDLE,
        PAUSE
    } state_t;

    state_t state, next_state;

    logic cache_miss, rd_miss, wr_miss;

    logic [16:0] tag_out;
    logic dirty;
    logic valid;

    //cache miss logic
    assign tag_out = tagline_out[16:0];
    assign dirty = tagline_out[17]; //dirty bit
    assign valid = tagline_out[18]; //valid bit

    //cache miss logic
    assign cache_miss = tag_out != MA_addr[31:15];
    assign rd_miss = cache_miss & MA_read_en;
    assign wr_miss = cache_miss & MA_write_en;

    logic [23:0] ddr_tagline;
    logic [66:0] ddr_wea;
    logic [511:0] ddr_data_in_fixed;

    assign enb = HIGH;
    assign data_out = doutb[511:0];
    assign tagline_out = doutb[535:512];

    assign dina = {tagline_in, data_in};
    assign addrb = addr;
    assign addra = addr;

    assign ddr_rd_miss = rd_miss | !valid;
    assign ddr_wr_miss = wr_miss | (!valid & !is_video_data);
    assign ddr_dirty = dirty & valid;
    assign is_video_data = MA_addr[27:23] ==  5'b11111;

    always_comb begin
        case(state) 
            STARTUP: begin
                ena = HIGH;
                wea = '1;
                addr = start_addr[14:6];
                data_in = '0;
                tagline_in = '0;
            end

            IDLE: begin
                data_in = regular_data_in;
                tagline_in = regular_tagline_in;
                wea = regular_wea;
                ena = (EX_addr[27:23] != 5'b11111);
                addr = EX_addr[14:6];
            end

            PAUSE: begin
                data_in =  ddr_data_in_fixed;
                tagline_in = ddr_tagline;
                wea = ddr_wea;
                ena = ddr_rd_done;
                addr = MA_addr[14:6];
            end

            default: begin
                data_in = regular_data_in;
                tagline_in = regular_tagline_in;
                wea = regular_wea;
                ena = (EX_addr[27:23] != 5'b11111);
                addr = EX_addr[14:6];
            end

        endcase
    end

    blk_mem_gen_0 freak_bob (
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

    always_comb begin

        //reading combinational logic
        MA_data_out = (state == PAUSE) ? ddr_data_in[MA_addr[5:2] * 32 +: 32] : data_out[MA_addr[5:2] * 32 +: 32];  //picks out right word

        //writing combinational logic no misses
        regular_tagline_in = {5'b0, 1'b1, 1'b1, EX_addr[31:15]};
        regular_data_in = '0;
        regular_wea = '0;

        //w/ misses
        ddr_data_in_fixed = ddr_data_in;
        ddr_tagline = {5'b0, 1'b1, 1'b0, MA_addr[31:15]};
        ddr_wea = '1;
        ddr_addr = MA_addr;

        if(EX_write_en) begin
            case(EX_mem_bytes)
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

                default: begin
                    regular_wea = '0;
                    regular_data_in = '0;
                end
            endcase
        end

        if(MA_write_en) begin
            case(MA_mem_bytes)
                2'b00: begin 
                    ddr_data_in_fixed = ddr_data_in;
                end

                2'b01: begin
                    ddr_data_in_fixed[MA_addr[5:0] * 8 +: 8] = MA_data_in[7:0];
                end
                
                2'b10: begin
                    ddr_data_in_fixed[{MA_addr[5:1], 1'b0} * 16 +: 16] = MA_data_in[15:0];
                end

                2'b11: begin
                    ddr_data_in_fixed[{MA_addr[5:2], 2'b00} * 32 +: 32] = MA_data_in;
                end

                default: begin
                   ddr_data_in_fixed = '0;
                end

            endcase
        end
        
    end
    

    always_comb begin

        case(state)
            STARTUP: begin
                if(start_done) begin
                    next_state = IDLE;
                    stall_out = LOW;
                end
                else begin
                    next_state = STARTUP;
                    stall_out = HIGH;
                end
            end
            IDLE: begin
                if (rd_miss | wr_miss | is_video_data) begin
                    next_state = PAUSE;
                    stall_out = HIGH;
                end
                else begin
                    next_state = IDLE;
                    stall_out = LOW;
                end
            end

            PAUSE: begin
                if(ddr_rd_done) begin
                    next_state = IDLE;                  
                end
                else begin
                    next_state = PAUSE;
                end
                stall_out = HIGH;
            end

            default: begin
                stall_out = LOW;
                next_state = IDLE;
            end
        endcase

    end

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= STARTUP;
            ddr_data_out <= '0;
        end 
        else begin
            state <= next_state;
            if(state == IDLE) begin
                ddr_data_out <= data_out;    
            end 
            else begin
                ddr_data_out <= ddr_data_out;
            end  
        end
    end

endmodule
