`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: Benjamin Li and Ryan Karami
// 
// Create Date: 06/05/2026 10:56:22 PM
// Design Name: Memory controller
// Module Name: Mem_ctrl
// Project Name: GOON-PU
// Target Devices: ARTY s7-25
// Tool Versions: VIVADO 25.2
// Description: GOON-PU memory controller FSMs for AXI read/write to DDR
// 
// Dependencies: brain
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
    output logic [511:0] ins_data_out, //[511:0] is actual data
    input logic ins_rd_miss,

    //data
    input logic [31:0] data_addr,
    input logic [511:0] data_data_in, //data coming in from cache
    output logic [511:0] data_data_out, //correct data going into cache
    input logic data_rd_miss,
    input logic data_wr_miss,
    input logic data_dirty,
    input logic video_data,

    //misc.
    output logic finish,
    output logic ins_read_done,
    output logic data_read_done,    //axi shi
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
    input logic rvalid,
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
        W_IDLE,
        W_SEND_ADDR,
        WRITE,
        PAUSE
    } write_state_t;

    typedef enum [1:0] {
        R_IDLE,
        R_SEND_ADDR,
        READ
    } read_state_t;

    logic write_start, read_start;
    logic write_done, read_done;

    mem_state_t mem_state, next_mem_state;
    write_state_t write_state, next_write_state;
    read_state_t read_state, next_read_state;

    logic [511:0] write_data_reg; //represents all bits of data that need to be written in write state machine;
    logic [511:0] read_data_reg; //represents all bits of data that need to be read;
    logic [511:0] next_read_data_reg;

    logic [31:0] write_addr_reg;
    logic [31:0] read_addr_reg;

    logic [31:0] next_write_addr_reg;
    logic [31:0] next_read_addr_reg;

    logic [1:0] write_cnt, next_write_cnt;
    logic [1:0] read_cnt, next_read_cnt;
    
    //setting aw defaults
    assign awlen = 8'd3;
    assign awsize = 3'b100;
    assign awburst = 2'b01;
    assign awlock = 1'b0;
    assign awcache = 4'b0011;
    assign awprot = 4'b000;
    assign awqos = 4'b0000;

    //setting ar defaults
    assign arlen = 8'd3;
    assign arsize = 3'b100;
    assign arburst = 2'b01;
    assign arlock = 1'b0;
    assign arcache = 4'b0011;
    assign arprot = 3'b000;
    assign arqos = 4'b0000;

    //setting w/r defaults
    assign wstrb = 16'b1111111111111111;



//seq shi for mem state machine
    always_ff @(posedge clk, negedge nrst) begin
        
        if (!nrst) begin
            mem_state <= IDLE;
        end

        else begin
            casez(mem_state)
                default: begin
                    data_data_out <= data_data_out;
                    ins_data_out <= ins_data_out;
                end

                DATA_WR_INS_RD: begin
                    data_data_out <= data_data_out;
                    ins_data_out <= read_data_reg;
                end

                DATA_RD_DIRT_INS_RD: begin
                    data_data_out <= data_data_out;
                    ins_data_out <= read_data_reg;
                end

                CLEAN_INS_RD: begin
                    data_data_out <= data_data_out;
                    ins_data_out <= read_data_reg;
                end

                DATA_RD: begin
                    data_data_out <= read_data_reg;
                    ins_data_out <= ins_data_out;
                end
            endcase

            mem_state <= next_mem_state;
            
        end
    end

    //memory state machine comb logic
    always_comb begin
        next_mem_state = IDLE;
        write_start = LOW;
        read_start = LOW;

        write_data_reg = '0;
        write_addr_reg = '0;
        read_addr_reg = '0;
        finish = LOW;
        data_read_done = LOW;
        ins_read_done = LOW;
        
        casez(mem_state)
            IDLE: begin
                if ((video_data | (data_wr_miss & data_dirty)) & !ins_rd_miss) begin
                    next_mem_state = DATA_WR;
                    write_start = HIGH;
                    read_start = LOW;
                end else if ((video_data | (data_wr_miss & data_dirty)) & ins_rd_miss) begin
                    next_mem_state = DATA_WR_INS_RD;
                    write_start = HIGH;
                    read_start = HIGH;
                end else if ((data_rd_miss & data_dirty) & !ins_rd_miss) begin
                    next_mem_state = DATA_RD_DIRT;
                    write_start = HIGH;
                    read_start = LOW;
                end else if ((data_rd_miss & data_dirty) & ins_rd_miss) begin
                    next_mem_state = DATA_RD_DIRT_INS_RD;
                    write_start = HIGH;
                    read_start = HIGH;
                end else if ((data_rd_miss & !data_dirty) & !ins_rd_miss) begin        
                    next_mem_state = DATA_RD;
                    write_start = LOW;
                    read_start = HIGH;
                end else if ((data_rd_miss & !data_dirty) & ins_rd_miss) begin        
                    next_mem_state = CLEAN_INS_RD;
                    write_start = LOW;
                    read_start = HIGH;
                end else if (data_wr_miss & !data_dirty) begin
                    next_mem_state = DATA_RD;
                    write_start = LOW;
                    read_start = HIGH;
                end else begin
                    next_mem_state = IDLE;
                    write_start = LOW;
                    read_start = LOW;
                end

                write_data_reg = '0;
                write_addr_reg = '0;
                read_addr_reg = '0;
                finish = LOW;
            end
            
            DATA_WR: begin
                if(write_done) begin
                    next_mem_state = (video_data) ? FINISH : DATA_RD;
                    write_start = (video_data) ? LOW : LOW;
                    read_start = (video_data) ? LOW : HIGH;
                end else begin
                    next_mem_state = DATA_WR;
                    write_start = LOW;
                    read_start = LOW;
                end

                write_data_reg = data_data_in;
                write_addr_reg = data_addr;
                read_addr_reg = '0;
                finish = LOW;
            end

            DATA_WR_INS_RD: begin
                if(write_done & read_done) begin
                    next_mem_state = (video_data) ? FINISH : DATA_RD;
                    write_start = (video_data) ? LOW : LOW;
                    read_start = (video_data) ? LOW : HIGH;
                end else begin
                    next_mem_state = DATA_WR_INS_RD;
                    write_start = LOW;
                    read_start = LOW;
                end

                write_data_reg = data_data_in;
                write_addr_reg = data_addr;
                read_addr_reg = ins_addr;
                finish = LOW;
                
                ins_read_done = (read_done);
            end

            DATA_RD_DIRT: begin
                next_mem_state = (write_done) ? DATA_RD : DATA_RD_DIRT;
                write_start = LOW;
                read_start = (write_done) ? HIGH : LOW;

                write_data_reg = data_data_in;
                write_addr_reg = data_addr;
                read_addr_reg = '0;
                finish = LOW;
            end

            DATA_RD_DIRT_INS_RD: begin
                next_mem_state = (write_done & read_done) ? DATA_RD : DATA_RD_DIRT_INS_RD;
                write_start = LOW;
                read_start = (write_done & read_done) ? HIGH : LOW;

                write_data_reg = data_data_in;
                write_addr_reg = data_addr;
                read_addr_reg = ins_addr;
                finish = LOW;

                ins_read_done = (read_done);
            end

            CLEAN_INS_RD: begin
                next_mem_state = (read_done) ? DATA_RD : CLEAN_INS_RD;
                write_start = LOW;
                read_start = (read_done) ? HIGH : LOW;

                write_data_reg = '0;
                write_addr_reg = '0;
                read_addr_reg = '0;
                finish = LOW;

                ins_read_done = (read_done);
            end

            DATA_RD: begin
                next_mem_state = (read_done) ? FINISH : DATA_RD;
                write_start = LOW;
                read_start = LOW;

                write_data_reg = '0;
                write_addr_reg = '0;
                read_addr_reg = data_addr;
                finish = LOW;

                data_read_done = (read_done);
            end

            FINISH: begin
                next_mem_state = IDLE;
                read_start= LOW;
                read_start = LOW;

                write_data_reg = '0;
                write_addr_reg = '0;
                read_addr_reg = '0;
                finish = HIGH;
            end            
        endcase
    end


    //read FSM seq

    always_ff @(posedge clk, negedge nrst) begin

        if (!nrst) begin
            read_state <= R_IDLE;
            arvalid <= LOW;
            rready <= LOW;
            read_data_reg <= '0;
        end

        else begin

            case(read_state) 

                default: begin
                    araddr <= araddr;
                    arvalid <= LOW;
                    rready <= LOW;
                end

                R_IDLE: begin
                    araddr <= araddr;
                    arvalid <= LOW;
                    rready <= LOW;
                end

                R_SEND_ADDR: begin
                    araddr <= read_addr_reg;
                    arvalid <= HIGH;
                    rready <= LOW;
                end
                
                READ: begin
                    araddr <= araddr;
                    arvalid <= LOW;
                    rready <= HIGH;
                end

            endcase

            read_state <= next_read_state;
            read_cnt <= next_read_cnt;
            read_data_reg <= next_read_data_reg;
        end
        
    end

    //read FSM comb
    always_comb begin
        
        next_read_state = read_state;
        read_done = LOW;
        next_read_cnt = read_cnt;
        next_read_data_reg = read_data_reg;
            
        casez(read_state) 
            
            R_IDLE: begin
                next_read_state = (read_start == HIGH) ? R_SEND_ADDR : R_IDLE;
                next_read_cnt = read_cnt;
                read_done = HIGH;
            end

            R_SEND_ADDR: begin
                next_read_state = (arready == HIGH) ? R_SEND_ADDR : R_IDLE;
                next_read_cnt = 2'd0;
                read_done = LOW;
            end

            READ: begin
                if(rvalid == HIGH) begin
                    next_read_data_reg[read_cnt * 128 +: 128] = rdata;
                    next_read_cnt = read_cnt + 2'd1;
                    next_read_state = (read_cnt == 2'd3) ? R_IDLE : READ;
                end else begin
                    next_read_cnt = read_cnt;
                    next_read_state = READ;
                end
                read_done = LOW;
            end
        endcase
    end

    //write FSM seq
    always_ff @(posedge clk, negedge nrst) begin

        if (!nrst) begin
            awaddr <= '0;
            wvalid <= LOW;
            awvalid <= LOW;
            wlast <= LOW;
            bready <= LOW;
            wdata <= '0; 
        end
        else begin

            case (write_state)

                W_IDLE: begin
                    awaddr <= awaddr;
                    wvalid <= LOW;
                    awvalid <= LOW;
                    wlast <= LOW;
                    bready <= LOW;
                    wdata <= wdata; 
                end

                W_SEND_ADDR: begin
                    awaddr <= write_addr_reg;
                    wvalid <= LOW;
                    awvalid <= HIGH;
                    wlast <= LOW;
                    bready <= LOW;
                    wdata <= wdata;
                end

                WRITE: begin
                    awaddr <= awaddr;
                    wvalid <= HIGH;
                    awvalid <= LOW;
                    wlast <= (write_cnt == 3) ? HIGH : LOW;
                    bready <= LOW;
                    wdata <= write_data_reg[write_cnt * 128 +: 128];
                end

                PAUSE: begin
                    awaddr <= awaddr;
                    wvalid <= LOW;
                    awvalid <= LOW;
                    wlast <= LOW;
                    bready <= HIGH;
                    wdata <= wdata;
                end

                default: begin
                    awaddr <= awaddr;
                    wvalid <= LOW;
                    awvalid <= LOW;
                    wlast <= LOW;
                    bready <= LOW;
                    wdata <= wdata;
                end

            endcase

            write_state <= next_write_state;
            write_cnt <= next_write_cnt;
            
        end
    end

    //write FSM comb
    always_comb begin
        next_write_state = write_state;
        write_done = LOW;
        next_write_cnt = write_cnt;

        casez(write_state)
            W_IDLE: begin
                next_write_state = (write_start == HIGH) ? W_SEND_ADDR : W_IDLE;
                write_done = HIGH;
                next_write_cnt = write_cnt;
            end

            W_SEND_ADDR: begin
                next_write_state = (awready == HIGH) ? WRITE : W_SEND_ADDR;
                write_done = LOW;
                next_write_cnt = 2'd0;
            end

            WRITE: begin
                if(wready == HIGH) begin
                    next_write_state = (write_cnt == 2'd3) ? PAUSE : WRITE;
                    next_write_cnt = write_cnt + 2'd1;
                end else begin
                    next_write_state = WRITE;
                    next_write_cnt = write_cnt;
                end
                write_done = LOW;
            end

            PAUSE: begin
                next_write_state = (bvalid == HIGH) ? W_IDLE : PAUSE;
                write_done = LOW;
                next_write_cnt = write_cnt;
            end

            default: begin
                next_write_state = write_state;
                write_done = LOW;
                next_write_cnt = write_cnt;
            end
        endcase
    end

endmodule
