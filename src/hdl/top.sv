`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 05:29:02 PM
// Design Name: 
// Module Name: top
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

`include "vivado_interfaces.svh"

module top(
    input logic CLK100MHZ,
    input logic ck_rst,

    //LEDs
    output logic [3:0] led;

    //uart
    input logic uart_rxd_out,
    output logic uart_txd_in,

    //HDMI
    output logic [2:0] hdmi_out_p, //order MSB to LSB: RED, GREEN, BLUE.
    output logic [2:0] hdmi_out_n,
    output logic hdmi_out_clk_p,
    output logic hdmi_out_clk_n
    
    //ddr3 memory
    inout wire [15:0] ddr3_sdram_dq,
    inout wire [1:0] ddr3_sdram_dqs_p,
    inout wire [1:0] ddr3_sdram_dqs_n,
    output wire [13:0] ddr3_sdram_addr,
    output wire [2:0] ddr3_sdram_ba,
    output wire ddr3_sdram_ras_n,
    output wire ddr3_sdram_cas_n,
    output wire ddr3_sdram_we_n,
    output wire ddr3_sdram_reset_n,
    output wire [0:0] ddr3_sdram_ck_p,
    output wire [0:0] ddr3_sdram_ck_n,
    output wire [0:0] ddr3_sdram_cke,
    output wire [0:0] ddr3_sdram_cs_n,
    output wire [1:0] ddr3_sdram_dm,
    output wire [0:0] ddr3_sdram_odt
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    //ip signals
    vivado_aximm_v1_0 S00_AXI_0();
    vivado_axi4_lite_v1_0 #(.ADDR_WIDTH(16)) S_AXI_LITE_0();
    logic reset; //reset going into mig

    //signals for other hdl
    logic clk, nrst;
    logic mig_ready;

    logic mmcm_locked_0, clk_locked; 

    logic clk_100M, clk_pixel, clk_serial;

    logic start_done, start_valid, start_write_en;
    logic [31:0] start_addr, start_data;

    logic boot_start;

    logic pkt_failed;

    assign sys_clk_i = CLK100MHZ;
    assign reset = ck_rst;
    assign mig_ready = init_calib_complete_0 & mmcm_locked_0;
    assign GND = LOW;

    assign clk = clk_100M;
    assign nrst = ck_rst;

    assign led[1] = pkt_failed;

    memory_sv your_instance_name (
        .S00_AXI_0(S00_AXI_0.slave), // vivado_aximm_v1_0.slave S00_AXI_0
        .S_AXI_LITE_0(S_AXI_LITE_0.slave), // vivado_axi4_lite_v1_0.slave S_AXI_LITE_0
        .ddr3_sdram_dq(ddr3_sdram_dq), // inout wire [15:0] ddr3_sdram_dq
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p), // inout wire [1:0] ddr3_sdram_dqs_p
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n), // inout wire [1:0] ddr3_sdram_dqs_n
        .ddr3_sdram_addr(ddr3_sdram_addr), // output wire [13:0] ddr3_sdram_addr
        .ddr3_sdram_ba(ddr3_sdram_ba), // output wire [2:0] ddr3_sdram_ba
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n), // output wire ddr3_sdram_ras_n
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n), // output wire ddr3_sdram_cas_n
        .ddr3_sdram_we_n(ddr3_sdram_we_n), // output wire ddr3_sdram_we_n
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n), // output wire ddr3_sdram_reset_n
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p), // output wire [0:0] ddr3_sdram_ck_p
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n), // output wire [0:0] ddr3_sdram_ck_n
        .ddr3_sdram_cke(ddr3_sdram_cke), // output wire [0:0] ddr3_sdram_cke
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n), // output wire [0:0] ddr3_sdram_cs_n
        .ddr3_sdram_dm(ddr3_sdram_dm), // output wire [1:0] ddr3_sdram_dm
        .ddr3_sdram_odt(ddr3_sdram_odt), // output wire [0:0] ddr3_sdram_odt
        .vid_io_out_0_active_video(vid_io_out_0_active_video), // output wire vid_io_out_0_active_video
        .vid_io_out_0_data(vid_io_out_0_data), // output wire [31:0] vid_io_out_0_data
        .vid_io_out_0_field(vid_io_out_0_field), // output wire vid_io_out_0_field
        .vid_io_out_0_hblank(vid_io_out_0_hblank), // output wire vid_io_out_0_hblank
        .vid_io_out_0_hsync(vid_io_out_0_hsync), // output wire vid_io_out_0_hsync
        .vid_io_out_0_vblank(vid_io_out_0_vblank), // output wire vid_io_out_0_vblank
        .vid_io_out_0_vsync(vid_io_out_0_vsync), // output wire vid_io_out_0_vsync
        .sys_clk_i(sys_clk_i), // input wire sys_clk_i
        .init_calib_complete_0(init_calib_complete_0), // output wire init_calib_complete_0
        .mmcm_locked_0(mmcm_locked_0), // output wire mmcm_locked_0
        .GND(GND), // input wire GND
        .clk_100M(clk_100M), // output wire clk_100M
        .clk_pixel(clk_pixel), // output wire clk_pixel
        .clk_serial(clk_serial), // output wire clk_serial
        .clk_locked(clk_locked), // output wire clk_locked
        .reset(reset) // input wire reset
    );

    bootloader boot(
        .uart_rx(uart_rxd_out),
        .axi_ctrl_bvalid(S00_AXI_0.BVALID)
    );

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
    output logic data_read_done,    
    
    //axi shi
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

    module vdma_controller(
    // AXI-Lite
    input axi_write_in_t axi_write_in,
    output axi_write_out_t axi_write_out,

    // General
    input logic clk,
    input logic nrst,
    input logic buffer_change,
    input logic startup_done
    );

    module HDMI(
    input logic pixel_clk,
    input logic serial_clk,
    input logic nrst,

    input logic vid_active,
    input logic [31:0] vid_data,
    input logic hsync,
    input logic vsync,
    input logic vid_field_id,
    input logic vid_hblank,
    input logic vid_vblank,

    output logic [2:0] hdmi_out_p, //order MSB to LSB: RED, GREEN, BLUE.
    output logic [2:0] hdmi_out_n,
    output logic hdmi_out_clk_p,
    output logic hdmi_out_clk_n

    );

    module CPU_top(

            input clk, nrst,

            //to Mem controller
            output logic [31:0] ins_addr,
            output logic ins_rd_miss,
            input logic [511:0] ins_data_out, //coming in to cache

            output logic [31:0] data_addr,
            output logic [511:0] data_data_in, //data coming  from cache
            input logic [511:0] data_data_out, //correct data going into cache
            output logic data_rd_miss,
            output logic data_wr_miss,
            output logic data_dirty,
            output logic video_data,

            input logic ins_read_done,
            input logic data_read_done,

            // from bootloader
            input start_valid, start_write_en,
            input start_done,
            input [31:0] start_addr,
            input [31:0] start_data,

            //to vdma
            output logic buffer_change

        );
endmodule
