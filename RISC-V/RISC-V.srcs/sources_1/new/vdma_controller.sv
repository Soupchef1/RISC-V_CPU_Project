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

    typedef enum logic[2:0] { 
        STARTUP,
        IDLE,
        WRITE_ADDR,
        WRITE_DATA,
        WAIT_RESPONSE
     } state_t;

    state_t state;
    state_t next_state;

    // VDMA utility and register addresses
    vdma_config_t vdma_config;

        // 720x480
    localparam logic[31:0] SCREEN_WIDTH = 32'd40960; // 720*WORD_LENGTH
    localparam logic[31:0] SCREEN_HEIGHT = 32'd480;
    localparam logic VDMA_ON = 1'b1;

    localparam logic[31:0] CONTROL_VALUE_ADDR   = 32'h0000_0000;
    localparam logic[31:0] PARK_PTR_ADDR        = 32'h0000_0028;
    localparam logic[31:0] START_ADDR1_ADDR     = 32'h0000_005C;
    localparam logic[31:0] START_ADDR2_ADDR     = 32'h0000_0060;
    localparam logic[31:0] DELAY_STRIDE_ADDR    = 32'h0000_0058;
    localparam logic[31:0] FRAME_WIDTH_ADDR     = 32'h0000_0054;
    localparam logic[31:0] FRAME_HEIGHT_ADDR    = 32'h0000_0050;

    //---------------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= STARTUP;
        end

        casez(state)

            STARTUP: begin
                // default values
                vdma_config.control_value = '0;
                vdma_config.control_value[0] = VDMA_ON;
                vdma_config.park_ptr = '0;
                vdma_config.start_addr1 = START_ADDR1_ADDR;
                vdma_config.start_addr2 = START_ADDR2_ADDR;
                vdma_config.delay_stride = '0;
                vdma_config.delay_stride[15:0] = 16'd40960;
                vdma_config.frame_width = SCREEN_WIDTH;
                vdma_config.frame_height = SCREEN_HEIGHT;
            end

        endcase
    end

    // ---------------------------------------------------------------------
    always_comb begin
        
    end
endmodule
