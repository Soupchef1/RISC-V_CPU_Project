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
import axi_lite_pkg::*;

module top(
    input logic CLK100MHZ,
    input logic ck_rst,

    //LEDs
    output logic [3:0] led,

    //uart
    input logic uart_rxd_out,
    output logic uart_txd_in,

    //HDMI
    output logic [2:0] hdmi_out_p, //order MSB to LSB: RED, GREEN, BLUE.
    output logic [2:0] hdmi_out_n,
    output logic hdmi_out_clk_p,
    output logic hdmi_out_clk_n,
    
    //ddr3 memory
    inout logic [15:0] ddr3_sdram_dq,
    inout logic [1:0] ddr3_sdram_dqs_p,
    inout logic [1:0] ddr3_sdram_dqs_n,
    output logic [13:0] ddr3_sdram_addr,
    output logic [2:0] ddr3_sdram_ba,
    output logic ddr3_sdram_ras_n,
    output logic ddr3_sdram_cas_n,
    output logic ddr3_sdram_we_n,
    output logic ddr3_sdram_reset_n,
    output logic [0:0] ddr3_sdram_ck_p,
    output logic [0:0] ddr3_sdram_ck_n,
    output logic [0:0] ddr3_sdram_cke,
    output logic [0:0] ddr3_sdram_cs_n,
    output logic [1:0] ddr3_sdram_dm,
    output logic [0:0] ddr3_sdram_odt
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

    //cache axi signals
    logic [31:0] cache_awaddr;
    logic [7:0] cache_awlen;   //should be 3, cuz its ts + 1 for actual size
    logic [2:0] cache_awsize;  //128 bits 
    logic [1:0] cache_awburst; 
    logic cache_awlock;
    logic [3:0] cache_awcache;
    logic [2:0] cache_awprot;
    logic [3:0] cache_awqos;
    logic cache_awvalid;

    logic [127:0] cache_wdata;
    logic [15:0] cache_wstrb;
    logic cache_wlast;
    logic cache_wvalid;

    logic cache_bready;

    logic [31:0] cache_araddr;
    logic [7:0] cache_arlen;
    logic [2:0] cache_arsize;
    logic [1:0] cache_arburst;
    logic cache_arlock;
    logic [3:0] cache_arcache;
    logic [2:0] cache_arprot;
    logic [3:0] cache_arqos;
    logic cache_arvalid;

    logic cache_rready;


    //cpu intermediate
    logic clk, nrst;
    
    //to Mem controller
    logic [31:0] ins_addr;
    logic ins_rd_miss;
    logic [511:0] ins_data_out; //coming in to cache
    logic [31:0] data_addr;
    logic [511:0] data_data_in; //data coming  from cache
    logic [511:0] data_data_out; //correct data going into cache
    logic data_rd_miss;
    logic data_wr_miss;
    logic data_dirty;
    logic video_data;
    logic ins_read_done;
    logic data_read_done;
    logic finish;
    
    // from bootloader
    logic start_valid, start_write_en, start_done;
    logic [31:0] start_addr;
    logic [31:0] start_data;
    
    //to vdma controller
    logic buffer_change;

    //VDMA signals
    axi_write_in_t axi_write_in;
    axi_write_out_t axi_write_out;

    //hdmi video signals
    logic vid_io_out_0_active_video; // output wire vid_io_out_0_active_video
    logic [31:0] vid_io_out_0_data; // output wire [31:0] vid_io_out_0_data
    logic vid_io_out_0_field; // output wire vid_io_out_0_field
    logic vid_io_out_0_hblank; // output wire vid_io_out_0_hblank
    logic vid_io_out_0_hsync; // output wire vid_io_out_0_hsync
    logic vid_io_out_0_vblank; // output wire vid_io_out_0_vblank
    logic vid_io_out_0_vsync; // output wire vid_io_out_0_vsync


    assign sys_clk_i = CLK100MHZ;
    assign reset = ck_rst;
    assign mig_ready = init_calib_complete_0 & mmcm_locked_0;
    assign GND = LOW;

    assign clk = clk_100M;
    assign nrst = ck_rst;

    assign led[0] = boot_start;
    assign led[1] = pkt_failed;
    assign led[2] = ins_rd_miss | data_rd_miss | data_wr_miss;
    assign led[3] = HIGH;

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
        .axi_ctrl_bvalid(S00_AXI_0.BVALID),
        .*
    );

    axi_ctrl nuisance (
        .write_en(start_write_en),
        
        .awaddr(S00_AXI_0.AWADDR),
        .awlen(S00_AXI_0.AWLEN),
        .awsize(S00_AXI_0.AWSIZE),
        .awburst(S00_AXI_0.AWBURST),
        .awlock(S00_AXI_0.AWLOCK),
        .awcache(S00_AXI_0.AWCACHE),
        .awprot(S00_AXI_0.AWPROT),
        .awqos(S00_AXI_0.AWQOS),
        .awvalid(S00_AXI_0.AWVALID),
        .awready(S00_AXI_0.AWREADY),

        .wdata(S00_AXI_0.WDATA),
        .wstrb(S00_AXI_0.WSTRB),
        .wlast(S00_AXI_0.WLAST),
        .wvalid(S00_AXI_0.WVALID),
        .wready(S00_AXI_0.WREADY),

        .bresp(S00_AXI_0.BRESP),
        .bvalid(S00_AXI_0.BVALID),
        .bready(S00_AXI_0.BREADY),

        .araddr(S00_AXI_0.ARADDR),
        .arlen(S00_AXI_0.ARLEN),
        .arsize(S00_AXI_0.ARSIZE),
        .arburst(S00_AXI_0.ARBURST),
        .arlock(S00_AXI_0.ARLOCK),
        .arcache(S00_AXI_0.ARCACHE),
        .arprot(S00_AXI_0.ARPROT),
        .arqos(S00_AXI_0.ARQOS),
        .arvalid(S00_AXI_0.ARVALID),
        .arready(S00_AXI_0.ARREADY),

        .rdata(S00_AXI_0.RDATA),
        .rresp(S00_AXI_0.RRESP),
        .rlast(S00_AXI_0.RLAST),
        .rvalid(S00_AXI_0.RVALID),
        .rready(S00_AXI_0.RREADY),
        .*
    );

    Mem_ctrl mem_control (
        .awaddr(cache_awaddr),
        .awlen(cache_awlen),
        .awsize(cache_awsize),
        .awburst(cache_awburst),
        .awlock(cache_awlock),
        .awcache(cache_awcache),
        .awprot(cache_awprot),
        .awqos(cache_awqos),
        .awvalid(cache_awvalid),
        .awready(S00_AXI_0.AWREADY),
        
        .wdata(cache_wdata),
        .wstrb(cache_wstrb),
        .wlast(cache_wlast),
        .wvalid(cache_wvalid),
        .wready(S00_AXI_0.WREADY),

        .bresp(S00_AXI_0.BRESP),
        .bvalid(S00_AXI_0.BVALID),
        .bready(cache_bready),

        .araddr(cache_araddr),
        .arlen(cache_arlen),
        .arsize(cache_arsize),
        .arburst(cache_arburst),
        .arlock(cache_arlock),
        .arcache(cache_arcache),
        .arprot(cache_arprot),
        .arqos(cache_arqos),
        .arvalid(cache_arvalid),
        .arready(S00_AXI_0.ARREADY),

        .rdata(S00_AXI_0.RDATA),
        .rresp(S00_AXI_0.RRESP),
        .rvalid(S00_AXI_0.RVALID),
        .rready(cache_rready),
        .*
    );

    vdma_controller trips_baby(
        .startup_done(start_done),
        .*
    );

    //connecting VDMA axi lite signals
    always_comb begin
        //outputs to VDMA
        S_AXI_LITE_0.AWADDR = axi_write_out.awaddr;
        S_AXI_LITE_0.AWVALID = axi_write_out.awvalid;
        S_AXI_LITE_0.WDATA = axi_write_out.wdata;
        S_AXI_LITE_0.WVALID = axi_write_out.wvalid;
        S_AXI_LITE_0.BREADY = axi_write_out.bready;

        //inputs from VDMA
        axi_write_in.awready = S_AXI_LITE_0.AWREADY;
        axi_write_in.wready = S_AXI_LITE_0.WREADY;
        axi_write_in.bresp = bresp_t'(S_AXI_LITE_0.BRESP);
        axi_write_in.bvalid = S_AXI_LITE_0.BVAILD;

        //unused r and ar channgel
        S_AXI_LITE_0.AWADDR = '0;
        S_AXI_LITE_0.AWVALID = HIGH;
        S_AXI_LITE_O.RREADY = HIGH;

    end


        
    HDMI trip_frames (
        .pixel_clk(clk_pixel),
        .serial_clk(clk_serial),
        .nrst(nrst),
        .vid_active(vid_io_out_0_active_video),
        .vid_data(vid_io_out_0_data),
        .hsync(vid_io_out_0_hsync),
        .vsync(vid_io_out_0_vsync),
        .vid_field_id(vid_io_out_0_field),
        .vid_hblank(vid_io_out_0_hblank),
        .vid_vblank(vid_io_out_0_vblank),
        .*
    );

    CPU_top  GOON_PU (
        .*
    );
    
endmodule
