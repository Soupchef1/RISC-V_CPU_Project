`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 07:23:13 PM
// Design Name: 
// Module Name: axi_ctrl
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


module axi_ctrl(
        //ogs
        input logic clk, nrst,

        //startup signals
        input logic boot_start, start_done,
        input logic [31:0] start_data, start_addr,
        input logic write_en,

        //mem controller axi signals
        input logic [31:0] cache_awaddr,
        input logic [7:0] cache_awlen,   //should be 3, cuz its ts + 1 for actual size
        input logic [2:0] cache_awsize,  //128 bits 
        input logic [1:0] cache_awburst, 
        input logic cache_awlock,
        input logic [3:0] cache_awcache,
        input logic [2:0] cache_awprot,
        input logic [3:0] cache_awqos,
        input logic cache_awvalid,

        input logic [127:0] cache_wdata,
        input logic [15:0] cache_wstrb,
        input logic cache_wlast,
        input logic cache_wvalid,

        input logic cache_bready,

        input logic [31:0] cache_araddr,
        input logic [7:0] cache_arlen,
        input logic [2:0] cache_arsize,
        input logic [1:0] cache_arburst,
        input logic cache_arlock,
        input logic [3:0] cache_arcache,
        input logic [2:0] cache_arprot,
        input logic [3:0] cache_arqos,
        input logic cache_arvalid,

        input logic cache_rready,

        //axi connections to dram
        output logic [31:0] awaddr,
        output logic [7:0] awlen,   //should be 3, cuz its ts + 1 for actual size
        output logic [2:0] awsize,  //128 bits 
        output logic [1:0] awburst, 
        output logic awlock,
        output logic [3:0] awcache,
        output logic [2:0] awprot,
        output logic [3:0] awqos,
        output logic awvalid,
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

    typedef enum logic [1:0] { 
        PAUSE,
        STARTUP,
        REGULAR
    } axi_state_t;

    axi_state_t state, next_state;

    logic [31:0] addr_reg, next_addr_reg; //stores 1 packet of data to be written in case axi gets backed up (not likely to occur)
    logic [31:0] data_reg, next_data_reg; 
    logic reg_used, next_reg_used;

    typedef enum logic [1:0] { 
        IDLE,
        SEND_ADDR,
        WRITE_DATA,
        CONFIRM
    } write_state_t;

    write_state_t write_state, next_write_state;

    logic [31:0] write_addr_reg, next_write_addr_reg;
    logic [31:0] write_data_reg, next_write_data_reg;

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= PAUSE;
            addr_reg <= '0;
            data_reg <= '0;
            reg_used <= LOW;

            write_state <= IDLE;
            write_addr_reg <= '0;
            write_data_reg <= '0;
        end else begin
            state <= next_state;
            addr_reg <= next_addr_reg;
            data_reg <= next_data_reg;
            reg_used <= next_reg_used;

            write_state <= next_write_state;
            write_addr_reg <= next_write_addr_reg;
            write_data_reg <= next_write_data_reg;
        end
    end

    always_comb begin
        casez(state)
            PAUSE: begin
                next_state = (boot_start) ? STARTUP : PAUSE;

                next_write_state = IDLE;
                next_write_addr_reg = '0;
                next_write_data_reg = '0;

                next_addr_reg = '0;
                next_data_reg = '0;
                next_reg_used = LOW;

                //axi
                awaddr = '0;
                awlen = '0;
                awsize = '0;
                awburst = 2'b01;
                awlock = '0;
                awcache = 4'b0011;
                awprot = 3'b000;
                awqos = 4'b0000;
                awvalid = LOW;

                wdata = '0;
                wstrb = '0;
                wlast = LOW;
                wvalid = LOW;

                bready = LOW;

                araddr = '0;
                arlen = '0;
                arsize = '0;
                arburst = 2'b01;
                arlock = '0;
                arcache = 4'b0011;
                arprot = 3'b000;
                arqos = 4'b0000;
                arvalid = LOW;

                rready = LOW;
            end

            STARTUP: begin
                next_state = (start_done) ? REGULAR : STARTUP;
                //values that need to change: awaddr, awvalid, wdata[31:0], wvalid, bready

                //axi write state machine
                casez(write_state)
                    IDLE: begin
                        if (reg_used) begin
                            next_write_state = SEND_ADDR;
                            next_write_addr_reg = addr_reg;
                            next_write_data_reg = data_reg;
                        end else if(write_en) begin
                            next_write_state = SEND_ADDR;
                            next_write_addr_reg = start_addr;
                            next_write_data_reg = start_data;
                        end else begin
                            next_write_state = IDLE;
                            next_write_addr_reg = '0;
                            next_write_data_reg = '0;
                        end

                        awaddr = '0;
                        awvalid = LOW;
                        wdata[31:0] = '0;
                        wvalid = LOW;
                        bready = LOW;
                    end

                    SEND_ADDR: begin
                        next_write_state = (awready == HIGH) ? WRITE_DATA : SEND_ADDR;
                        next_write_addr_reg = write_addr_reg;
                        next_write_data_reg = write_data_reg;
                        
                        awaddr = write_addr_reg;
                        awvalid = HIGH;
                        wdata[31:0] = '0;
                        wvalid = LOW;
                        bready = LOW;
                    end

                    WRITE_DATA: begin
                        next_write_state = (wready == HIGH) ? CONFIRM : WRITE_DATA;
                        next_write_addr_reg = write_addr_reg;
                        next_write_data_reg = write_data_reg;
                        
                        awaddr = '0;
                        awvalid = LOW;
                        wdata[31:0] = write_data_reg;
                        wvalid = HIGH;
                        bready = LOW;
                    end

                    CONFIRM: begin
                        next_write_state = (bvalid == HIGH) ? IDLE : CONFIRM;
                        next_write_addr_reg = write_addr_reg;
                        next_write_data_reg = write_data_reg;
                        
                        awaddr = '0;
                        awvalid = LOW;
                        wdata[31:0] = '0;
                        wvalid = LOW;
                        bready = HIGH;
                    end
                endcase

                //backup register logic
                if(write_state != IDLE) begin
                    if(write_en) begin
                        next_addr_reg = start_addr;
                        next_data_reg = start_data;
                        next_reg_used = HIGH;
                    end else begin
                        next_addr_reg = addr_reg;
                        next_data_reg = data_reg;
                        next_reg_used = HIGH;
                    end
                end else begin
                    next_write_reg = '0;
                    next_data_reg = '0;
                    next_reg_used = LOW;
                end

                //stagnant axi values in startup
                awlen = 8'b0000;
                awsize = 3'b010;
                awburst = 2'b01;
                awlock = LOW;
                awcache = 4'b0011;
                awprot = 3'b000;
                awqos = 4'b0000;
                
                wdata[127:32] = '0;
                wstrb = 16'h000F; //only writing bottom 32 bits
                wlast = HIGH; //keep wlast high because only ever sending 1 beat of data

                araddr = '0;
                arlen = 8'b0000;
                arsize = 3'b010;
                arburst = 2'b01;
                arlock = LOW;
                arcache = 4'b0011;
                arprot = 3'b000;
                arqos = 4'b0000;
                arvalid = LOW;

                rready = LOW;
            end

            REGULAR: begin
                next_state = REGULAR;

                next_write_state = IDLE;
                next_write_addr_reg = '0;
                next_write_data_reg = '0;

                next_addr_reg = '0;
                next_data_reg = '0;
                next_reg_used = LOW;

                //axi
                awaddr = cache_awaddr;
                awlen = cache_awlen;
                awsize = cache_awsize;
                awburst = cache_awburst;
                awlock = cache_awlock;
                awcache = cache_awcache;
                awprot = cache_awprot;
                awqos = cache_awqos;
                awvalid = cache_awvalid;

                wdata = cache_wdata;
                wstrb = cache_wstrb;
                wlast = cache_wlast;
                wvalid = cache_wvalid;

                bready = cache_bready;

                araddr = cache_araddr;
                arlen = cache_arlen;
                arsize = cache_arsize;
                arburst = cache_arburst;
                arlock = cache_arlock;
                arcache = cache_arcache;
                arprot = cache_arprot;
                arqos = cache_arqos;
                arvalid = cache_arvalid;

                rready = cache_rready;
            end

            default: begin
                next_state = REGULAR;

                next_write_state = IDLE;
                next_write_addr_reg = '0;
                next_write_data_reg = '0;

                next_addr_reg = '0;
                next_data_reg = '0;
                next_reg_used = LOW;

                //axi
                awaddr = '0;
                awlen = '0;
                awsize = '0;
                awburst = 2'b01;
                awlock = '0;
                awcache = 4'b0011;
                awprot = 3'b000;
                awqos = 4'b0000;
                awvalid = LOW;

                wdata = '0;
                wstrb = '0;
                wlast = LOW;
                wvalid = LOW;

                bready = LOW;

                araddr = '0;
                arlen = '0;
                arsize = '0;
                arburst = 2'b01;
                arlock = '0;
                arcache = 4'b0011;
                arprot = 3'b000;
                arqos = 4'b0000;
                arvalid = LOW;

                rready = LOW;
            end
        endcase 
    end
endmodule
