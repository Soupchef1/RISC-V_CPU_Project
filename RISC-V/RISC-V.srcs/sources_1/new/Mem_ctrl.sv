`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2026 10:56:22 PM
// Design Name: 
// Module Name: Mem_ctrl
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

//have to deal with: BRAM data, BRAM addr, current cache tag, new data in, write en, read en


module Mem_ctrl(
    
    //the ogs
    input logic clk,
    input logic nrst,

    //instruction
    input logic [31:0] ins_addr,
    output logic [535:0] ins_data_out, //[511:0] is actual data, [535:512] is tagline
    input logic ins_rd_miss,

    //data
    input logic [31:0] data_addr,
    input logic [511:0] data_data_in, //data coming in from cache
    output logic [535:0] data_data_out, //correct data going into cache
    input logic data_rd_miss,
    input logic data_wr_miss,
    input logic data_dirty,
    input logic video_data,

    //misc.
    output logic finish,

    //axi shi
    output logic [31:0] awaddr,
    output logic [7:0] awlen,   //should be 3, cuz its ts + 1 for actual size
    output logic [2:0] awsize,  //128 bits 
    output logic [1:0] awburst, 
    output logic awlock,
    output logic [3:0] awcache,
    output logic [2:0] awprot,
    output logic [3:0] awqos,
    input logic awready,

    output logic [127:0] wdata,
    output logic [15:0] wstrb,
    output logic wlast,
    output logic wvalid,
    input logic wready,

    input logic [1:0] bresp,
    input logic bvalid,
    output logic bready,

    output logic [31:0] araddr,
    output logic [7:0] arlen,
    output logic [2:0] arsize,
    output logic [1:0] arburst,
    output logic arlock,
    output logic [3:0] arcache,
    output logic [2:0] arprot,
    output logic [3:0] arqos,
    output logic arvalid,
    input logic arready,
    
    input logic [127:0] rdata,
    input logic [1:0] rresp,
    input logic rlast,
    input logic rvalidl,
    output logic rready    
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    typedef enum [2:0] { 
        IDLE,
        DATA_WR,
        DATA_WR_INS_RD,
        DATA_RD_DIRT_INS_RD,
        DATA_RD_DIRT,
        CLEAN_INS_RD,
        DATA_RD,
        FINISH
    } mem_state_t;

    typedef enum [1:0] {
        IDLE,
        SEND_ADDR,
        WRITE,
        WAIT
    } write_state_t;

    typedef enum [1:0] {
        IDLE,
        SEND_ADDR,
        WRITE
    } write_state_t;

    logic write_start, read_start;
    logic write_done, read_done;
    logic next_write_start, next_read_start;

    mem_state_t mem_state, next_mem_state;
    write_state_t write_state, next_write_state;
    read_state_t read_state, next_read_state;

    logic [511:0] write_data_reg; //represents all bits of data that need to be written in write state machine;
    logic [511:0] read_data_reg; //represents all bits of data that need to be read;

    logic [31:0] write_addr_reg;
    logic [31:0] read_addr_reg;

    always_ff @(posedge or negedge nrst) begin
        
        if (!nrst) begin
            mem_state <= IDLE;
            write_start <= LOW;
            read_start <= LOW;
            write_data_reg <= '0;
            write_addr_reg <= '0;
            read_addr_reg <= '0;
            finish <= LOW;
        end

        else begin

            case (meme_state)

                default: begin
                    write_data_reg <= '0;
                    write_addr_reg <= '0;
                    read_addr_reg <= '0;
                    finish <= LOW;
                end

                IDLE: begin
                    write_data_reg <= '0;
                    write_addr_reg <= '0;
                    read_addr_reg <= '0;
                    finish <= LOW;
                end

                DATA_WR: begin
                    write_data_reg <= data_data_in;
                    write_addr_reg <= data_addr;
                    read_addr_reg <= '0;
                    finish <= LOW;

                end
                
                DATA_WR_INS_RD: begin
                    write_data_reg <= data_data_in;
                    write_addr_reg <= data_addr;
                    read_addr_reg <= ins_addr;
                    finish <= LOW;

                end

                DATA_RD_DIRT_INS_RD: begin
                    write_data_reg <= data_data_in;
                    write_addr_reg <= data_addr;
                    read_addr_reg <= ins_addr;
                    finish <= LOW;
                end

                DATA_RD_DIRT: begin
                    write_data_reg <= data_data_in;
                    write_addr_reg <= data_addr;
                    read_addr_reg <= '0;
                    finish <= LOW;
                end

                CLEAN_INS_RD: begin
                    write_data_reg <= '0;
                    write_addr_reg <= '0;
                    read_addr_reg <= '0;
                    finish <= LOW;
                end

                DATA_RD: begin
                    write_data_reg <= '0;
                    write_addr_reg <= '0;
                    read_addr_reg <= data_addr;
                    finish <= LOW;
                end

                FINISH: begin
                    write_data_reg <= '0;
                    write_addr_reg <= '0;
                    read_addr_reg <= '0;
                    finish <= HIGH;
                end
                
            endcase

            mem_state <= next_mem_state;
            write_start <= next_write_start;
            read_start <= next_read_start;
            
        end
    end

    //memory state machine comb logic
    always_comb begin
        next_mem_state = IDLE;
        next_write_start = LOW;
        next_read_start = LOW;

        
        casez(mem_state)
            IDLE: begin
                if((video_data | (data_write_miss & dirty) & !instr_read_miss)) begin
                    next_mem_state = DATA_WR;
                    next_write_start = HIGH;
                    next_read_start = LOW;
                end else ((video_data | (data_write_miss & dirty) & instr_read_miss)) begin
                    next_mem_state = DATA_WR_INS_RD;
                    next_write_start = HIGH;
                    next_read_start = HIGH;
                end else if ((data_rd_miss & data_dirty) & !instr_read_miss) begin
                    next_mem_state = DATA_RD_DIRT;
                    next_write_start = HIGH;
                    next_read_start = LOW;
                end else if ((data_rd_miss & data_dirty) & instr_read_miss) begin
                    next_mem_state = DATA_RD_DIRT_INS_RD;
                    next_write_start = HIGH;
                    next_read_start = HIGH;
                end else if ((data_rd_miss & !data_dirty) & !instr_read_miss) begin        
                    next_mem_state = DATA_RD;
                    next_write_start = LOW;
                    next_read_start = HIGH;
                end else if ((data_rd_miss & !data_dirty) & instr_read_miss) begin        
                    next_mem_state = CLEAN_INS_RD;
                    next_write_start = LOW;
                    next_read_start = HIGH;
                end else begin
                    next_mem_state = IDLE;
                    next_write_start = LOW;
                    next_read_start = LOW;
                end
            end
            
            DATA_WR: begin
                next_mem_state = (write_done) ? FINISH : DATA_WR;
                next_write_start = LOW;
                next_read_start = LOW;
            end

            DATA_WR_INS_RD: begin
                next_mem_state = (write_done & read_done) ? FINISH : DATA_WR_INS_RD;
                next_write_start = LOW;
                next_read_start = LOW;
            end

            DATA_RD_DIRT: begin
                next_mem_state = (write_done) ? DATA_RD : DATA_RD_DIRT;
                next_write_start = LOW;
                next_read_start = (write_done) ? HIGH : LOW;
            end

            DATA_RD_DIRT_INS_RD: begin
                next_mem_state = (write_done & read_done) ? DATA_RD : DATA_RD_DIRT_INS_RD;
                next_write_start = LOW;
                next_read_start = (write_done & read_done) ? HIGH : LOW;
            end

            CLEAN_INS_RD: begin
                next_mem_state = (read_done) ? DATA_RD : CLEAN_INS_RD;
                next_write_start = LOW;
                next_read_start = (read_done) ? HIGH : LOW;
            end

            DATA_RD: begin
                next_mem_state = (read_done) ? FINISH : DATA_RD;
                next_write_start = LOW;
                next_read_start = LOW;
            end

            FINISH: begin
                next_mem_state = IDLE;
                next_read_start= LOW;
                next_read_start = LOW;
            end            
        endcase
    end



endmodule
