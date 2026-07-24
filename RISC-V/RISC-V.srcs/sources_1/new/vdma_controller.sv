`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2026 10:51:36 PM
// Design Name: 
// Module Name: vdma_controller
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

// Axi-lite protocol: https://www.realdigital.org/doc/a9fee931f7a172423e1ba73f66ca4081
localparam logic HIGH = 1'b1;
localparam logic LOW = 1'b0;
import axi_lite_pkg::*;

// VDMA config
typedef struct packed {
    logic[31:0] control_value;
    logic[31:0] park_ptr;
    logic[31:0] start_addr1;
    logic[31:0] start_addr2;
    logic[31:0] delay_stride;
    logic[31:0] frame_width;
    logic[31:0] frame_height;
} vdma_config_t;


module vdma_controller(
    // AXI-Lite
    input axi_write_in_t axi_write_in,
    output axi_write_out_t axi_write_out,

    // General
    input logic clk,
    input logic nrst,
    input logic buffer_change,
    output logic confirm_change,
    );

    // State definitions
    typedef enum logic[1:0] { 
        AXI_IDLE,
        AXI_WRITE_ADDR_DATA,
        AXI_WAIT_RESPONSE,
        AXI_CHECK_RESPONSE
     } axi_state_t;

    axi_state_t axi_state;

    // main FSM -> AXI
    logic write_start;
    logic write_address;
    logic write_data;

    // AXI -> main FSM
    logic write_busy;
    logic write_done;
    logic write_error;

    typedef enum logic[1:0] { 
        STARTUP,
        IDLE,
        CHANGING_FRAME
    } controller_state_t;

    controller_state_t controller_state;

    // VDMA utility and register addresses
    vdma_config_t vdma_config;

    typedef enum logic[2:0] { 
        SEND_CONTROL_VALUE,
        SEND_PARK_PTR,
        SEND_START_ADDR1,
        SEND_START_ADDR2,
        SEND_DELAY_STRIDE,
        SEND_FRAME_WIDTH,
        SEND_FRAME_HEIGHT
    } vdma_axi_startup_index_t;

    vdma_axi_startup_index_t startup_index;

        // 1280x720
    localparam logic[31:0] SCREEN_WIDTH         = 32'd40960; // 1280*WORD_LENGTH
    localparam logic[31:0] SCREEN_HEIGHT        = 32'd720;
    localparam logic[31:0] DEF_DELAY_STRIDE     = 32'd40960;
    logic VDMA_ON                    = 32'b1;

    localparam logic[31:0] CONTROL_VALUE_ADDR   = 32'h0000_0000;
    localparam logic[31:0] PARK_PTR_ADDR        = 32'h0000_0028;
    localparam logic[31:0] START_ADDR1_ADDR     = 32'h0000_005C;
    localparam logic[31:0] START_ADDR2_ADDR     = 32'h0000_0060;
    localparam logic[31:0] DELAY_STRIDE_ADDR    = 32'h0000_0058;
    localparam logic[31:0] FRAME_WIDTH_ADDR     = 32'h0000_0054;
    localparam logic[31:0] FRAME_HEIGHT_ADDR    = 32'h0000_0050;

    vdma_config_t DEFAULT_CONFIG = '{
        control_value : VDMA_ON,
        park_ptr : '0,
        start_addr1 : START_ADDR1_ADDR,
        start_addr2 : START_ADDR2_ADDR,
        delay_stride : DEF_DELAY_STRIDE,
        frame_width : SCREEN_WIDTH,
        frame_height : SCREEN_HEIGHT,
        };

    //VDMA Controller FSM---------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            write_status <= WRITE_IDLE;
            controller_state <= STARTUP;
        end

        casez(controller_state) 
            STARTUP: begin
                startup_index = SEND_CONTROL_VALUE;

                casez(startup_index)
                    SEND_CONTROL_VALUE: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_PARK_PTR;
                        end
                    end

                    SEND_PARK_PTR: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_START_ADDR1;
                        end
                    end

                    SEND_START_ADDR1: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_START_ADDR2;
                        end
                    end

                    SEND_START_ADDR2: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_DELAY_STRIDE;
                        end
                    end

                    SEND_DELAY_STRIDE: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_FRAME_WIDTH;
                        end
                    end

                    SEND_FRAME_WIDTH: begin
                        if(write_done == HIGH) begin
                            startup_index <= SEND_FRAME_HEIGHT;
                        end
                    end

                    SEND_FRAME_HEIGHT: begin
                        if(write_done == HIGH) begin
                            controller_state <= IDLE; //END OF CONFIG STARTUP
                        end
                    end
                endcase

            end

            IDLE: begin
                if(buffer_change == HIGH) begin
                    confirm_change <= HIGH;
                    controller_state <= CHANGING_FRAME;
                end
            end

            CHANGING_FRAME: begin
            end
        endcase
    end

    always_comb begin
        casez(controller_state)
            STARTUP: begin
                casez(startup_index)
                    SEND_CONTROL_VALUE: begin
                        if(!write_busy) begin
                            write_address = CONTROL_VALUE_ADDR;
                            write_data = DEFAULT_CONFIG.control_value;
                            write_start = HIGH;
                        end
                    end

                    SEND_PARK_PTR: begin
                        if(!write_busy) begin
                            write_address = PARK_PTR_ADDR;
                            write_data = DEFAULT_CONFIG.park_ptr;
                            write_start = HIGH;
                        end
                    end

                    SEND_START_ADDR1: begin
                        if(!write_busy) begin
                            write_address = START_ADDR1_ADDR;
                            write_data = DEFAULT_CONFIG.start_addr1;
                            write_start = HIGH;
                        end
                    end

                    SEND_START_ADDR2: begin
                        if(!write_busy) begin
                            write_address = START_ADDR2_ADDR;
                            write_data = DEFAULT_CONFIG.start_addr2;
                            write_start = HIGH;
                        end
                    end

                    SEND_DELAY_STRIDE: begin
                        if(!write_busy) begin
                            write_address = DELAY_STRIDE_ADDR;
                            write_data = DEFAULT_CONFIG.delay_stride;
                            write_start = HIGH;
                        end
                    end

                    SEND_FRAME_WIDTH: begin
                        if(!write_busy) begin
                            write_address = FRAME_WIDTH_ADDR;
                            write_data = DEFAULT_CONFIG.frame_width;
                            write_start = HIGH;
                        end
                    end

                    SEND_FRAME_HEIGHT: begin
                        if(!write_busy) begin
                            write_address = START_ADDR1_ADDR;
                            write_data = DEFAULT_CONFIG.start_addr1;
                            write_start = HIGH;
                        end
                    end
                endcase
            end

            IDLE: begin
            end

            CHANGING_FRAME: begin
                if(!write_busy) begin
                    write_address = PARK_PTR_ADDR;
                    
                end
            end
        endcase
    end

    //AXI-TRANSACTION FSM---------------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            axi_state <= AXI_IDLE;
        end

        casez(axi_state)

            AXI_IDLE: begin
                if(write_status == WRITE_START)begin
                    axi_state <= AXI_WRITE_ADDR_DATA;
                end
            end

            AXI_WRITE_ADDR_DATA: begin
                if(axi_write_in.wready == HIGH) begin
                    axi_state <= AXI_WAIT_RESPONSE;
                end
            end

            AXI_WAIT_RESPONSE: begin
                if(axi_write_in.bvalid) begin
                    axi_state <= READ_RESPONSE;
                end
            end

            AXI_CHECK_RESPONSE: begin
                if(axi_write_in.bresp != AXI_OKAY) begin
                    axi_state <= AXI_IDLE; //reset on bad write
                    confirm_write = WRITE_ERROR;
                end

                else begin
                    axi_state <= AXI_IDLE;
                    confirm_write = WRITE_DONE;
                end
            end
        endcase
    end

    // AXI-TRANSACTION SIGNAL LOGIC ---------------------------------------------------------------------
    always_comb begin
        casez(axi_state) 

            AXI_IDLE: begin
                axi_write_out.awaddr = '0;
                axi_write_out.awvalid = LOW;
                axi_write_out.wdata = '0;
                axi_write_out.wvalid = LOW;
                axi_write_out.bready = LOW;
            end

            AXI_WRITE_ADDR_DATA: begin
                confirm_change = HIGH;
                axi_write_out.awaddr = axi_address;
                axi_write_out.awvalid = HIGH;
                axi_write_out.wdata = axi_data;
                axi_write_out.wvalid = HIGH;
                axi_write_out.bready = LOW;
            end

            AXI_WAIT_RESPONSE: begin
                axi_write_out.awaddr = '0;
                axi_write_out.awvalid = LOW;
                axi_write_out.wdata = '0;
                axi_write_out.wvalid = LOW;

                if(axi_write_in.bvalid == HIGH) begin
                    axi_write_out.bready = HIGH;
                end

                else begin
                    axi_write_out.bready = LOW;
                end
            end

            AXI_CHECK_RESPONSE: begin
                
            end
        endcase
    end
endmodule
