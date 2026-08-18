//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Mon Aug 17 01:30:15 2026
//Host        : DESKTOP-RCMS6DA running 64-bit major release  (build 9200)
//Command     : generate_target memory_wrapper.bd
//Design      : memory_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module memory_wrapper
   (GND,
    HIGH,
    S00_AXI_0_araddr,
    S00_AXI_0_arburst,
    S00_AXI_0_arcache,
    S00_AXI_0_arlen,
    S00_AXI_0_arlock,
    S00_AXI_0_arprot,
    S00_AXI_0_arqos,
    S00_AXI_0_arready,
    S00_AXI_0_arregion,
    S00_AXI_0_arsize,
    S00_AXI_0_arvalid,
    S00_AXI_0_awaddr,
    S00_AXI_0_awburst,
    S00_AXI_0_awcache,
    S00_AXI_0_awlen,
    S00_AXI_0_awlock,
    S00_AXI_0_awprot,
    S00_AXI_0_awqos,
    S00_AXI_0_awready,
    S00_AXI_0_awregion,
    S00_AXI_0_awsize,
    S00_AXI_0_awvalid,
    S00_AXI_0_bready,
    S00_AXI_0_bresp,
    S00_AXI_0_bvalid,
    S00_AXI_0_rdata,
    S00_AXI_0_rlast,
    S00_AXI_0_rready,
    S00_AXI_0_rresp,
    S00_AXI_0_rvalid,
    S00_AXI_0_wdata,
    S00_AXI_0_wlast,
    S00_AXI_0_wready,
    S00_AXI_0_wstrb,
    S00_AXI_0_wvalid,
    S_AXI_LITE_0_araddr,
    S_AXI_LITE_0_arready,
    S_AXI_LITE_0_arvalid,
    S_AXI_LITE_0_awaddr,
    S_AXI_LITE_0_awready,
    S_AXI_LITE_0_awvalid,
    S_AXI_LITE_0_bready,
    S_AXI_LITE_0_bresp,
    S_AXI_LITE_0_bvalid,
    S_AXI_LITE_0_rdata,
    S_AXI_LITE_0_rready,
    S_AXI_LITE_0_rresp,
    S_AXI_LITE_0_rvalid,
    S_AXI_LITE_0_wdata,
    S_AXI_LITE_0_wready,
    S_AXI_LITE_0_wvalid,
    aresetn,
    clk_100M,
    clk_locked,
    clk_pixel,
    clk_serial,
    ddr3_sdram_addr,
    ddr3_sdram_ba,
    ddr3_sdram_cas_n,
    ddr3_sdram_ck_n,
    ddr3_sdram_ck_p,
    ddr3_sdram_cke,
    ddr3_sdram_cs_n,
    ddr3_sdram_dm,
    ddr3_sdram_dq,
    ddr3_sdram_dqs_n,
    ddr3_sdram_dqs_p,
    ddr3_sdram_odt,
    ddr3_sdram_ras_n,
    ddr3_sdram_reset_n,
    ddr3_sdram_we_n,
    init_calib_complete_0,
    mig_reset,
    mmcm_locked_0,
    sys_clk_i,
    vid_io_out_0_active_video,
    vid_io_out_0_data,
    vid_io_out_0_field,
    vid_io_out_0_hblank,
    vid_io_out_0_hsync,
    vid_io_out_0_vblank,
    vid_io_out_0_vsync);
  input GND;
  input HIGH;
  input [31:0]S00_AXI_0_araddr;
  input [1:0]S00_AXI_0_arburst;
  input [3:0]S00_AXI_0_arcache;
  input [7:0]S00_AXI_0_arlen;
  input [0:0]S00_AXI_0_arlock;
  input [2:0]S00_AXI_0_arprot;
  input [3:0]S00_AXI_0_arqos;
  output [0:0]S00_AXI_0_arready;
  input [3:0]S00_AXI_0_arregion;
  input [2:0]S00_AXI_0_arsize;
  input [0:0]S00_AXI_0_arvalid;
  input [31:0]S00_AXI_0_awaddr;
  input [1:0]S00_AXI_0_awburst;
  input [3:0]S00_AXI_0_awcache;
  input [7:0]S00_AXI_0_awlen;
  input [0:0]S00_AXI_0_awlock;
  input [2:0]S00_AXI_0_awprot;
  input [3:0]S00_AXI_0_awqos;
  output [0:0]S00_AXI_0_awready;
  input [3:0]S00_AXI_0_awregion;
  input [2:0]S00_AXI_0_awsize;
  input [0:0]S00_AXI_0_awvalid;
  input [0:0]S00_AXI_0_bready;
  output [1:0]S00_AXI_0_bresp;
  output [0:0]S00_AXI_0_bvalid;
  output [127:0]S00_AXI_0_rdata;
  output [0:0]S00_AXI_0_rlast;
  input [0:0]S00_AXI_0_rready;
  output [1:0]S00_AXI_0_rresp;
  output [0:0]S00_AXI_0_rvalid;
  input [127:0]S00_AXI_0_wdata;
  input [0:0]S00_AXI_0_wlast;
  output [0:0]S00_AXI_0_wready;
  input [15:0]S00_AXI_0_wstrb;
  input [0:0]S00_AXI_0_wvalid;
  input [8:0]S_AXI_LITE_0_araddr;
  output S_AXI_LITE_0_arready;
  input S_AXI_LITE_0_arvalid;
  input [8:0]S_AXI_LITE_0_awaddr;
  output S_AXI_LITE_0_awready;
  input S_AXI_LITE_0_awvalid;
  input S_AXI_LITE_0_bready;
  output [1:0]S_AXI_LITE_0_bresp;
  output S_AXI_LITE_0_bvalid;
  output [31:0]S_AXI_LITE_0_rdata;
  input S_AXI_LITE_0_rready;
  output [1:0]S_AXI_LITE_0_rresp;
  output S_AXI_LITE_0_rvalid;
  input [31:0]S_AXI_LITE_0_wdata;
  output S_AXI_LITE_0_wready;
  input S_AXI_LITE_0_wvalid;
  input aresetn;
  output clk_100M;
  output clk_locked;
  output clk_pixel;
  output clk_serial;
  output [13:0]ddr3_sdram_addr;
  output [2:0]ddr3_sdram_ba;
  output ddr3_sdram_cas_n;
  output [0:0]ddr3_sdram_ck_n;
  output [0:0]ddr3_sdram_ck_p;
  output [0:0]ddr3_sdram_cke;
  output [0:0]ddr3_sdram_cs_n;
  output [1:0]ddr3_sdram_dm;
  inout [15:0]ddr3_sdram_dq;
  inout [1:0]ddr3_sdram_dqs_n;
  inout [1:0]ddr3_sdram_dqs_p;
  output [0:0]ddr3_sdram_odt;
  output ddr3_sdram_ras_n;
  output ddr3_sdram_reset_n;
  output ddr3_sdram_we_n;
  output init_calib_complete_0;
  input mig_reset;
  output mmcm_locked_0;
  input sys_clk_i;
  output vid_io_out_0_active_video;
  output [23:0]vid_io_out_0_data;
  output vid_io_out_0_field;
  output vid_io_out_0_hblank;
  output vid_io_out_0_hsync;
  output vid_io_out_0_vblank;
  output vid_io_out_0_vsync;

  wire GND;
  wire HIGH;
  wire [31:0]S00_AXI_0_araddr;
  wire [1:0]S00_AXI_0_arburst;
  wire [3:0]S00_AXI_0_arcache;
  wire [7:0]S00_AXI_0_arlen;
  wire [0:0]S00_AXI_0_arlock;
  wire [2:0]S00_AXI_0_arprot;
  wire [3:0]S00_AXI_0_arqos;
  wire [0:0]S00_AXI_0_arready;
  wire [3:0]S00_AXI_0_arregion;
  wire [2:0]S00_AXI_0_arsize;
  wire [0:0]S00_AXI_0_arvalid;
  wire [31:0]S00_AXI_0_awaddr;
  wire [1:0]S00_AXI_0_awburst;
  wire [3:0]S00_AXI_0_awcache;
  wire [7:0]S00_AXI_0_awlen;
  wire [0:0]S00_AXI_0_awlock;
  wire [2:0]S00_AXI_0_awprot;
  wire [3:0]S00_AXI_0_awqos;
  wire [0:0]S00_AXI_0_awready;
  wire [3:0]S00_AXI_0_awregion;
  wire [2:0]S00_AXI_0_awsize;
  wire [0:0]S00_AXI_0_awvalid;
  wire [0:0]S00_AXI_0_bready;
  wire [1:0]S00_AXI_0_bresp;
  wire [0:0]S00_AXI_0_bvalid;
  wire [127:0]S00_AXI_0_rdata;
  wire [0:0]S00_AXI_0_rlast;
  wire [0:0]S00_AXI_0_rready;
  wire [1:0]S00_AXI_0_rresp;
  wire [0:0]S00_AXI_0_rvalid;
  wire [127:0]S00_AXI_0_wdata;
  wire [0:0]S00_AXI_0_wlast;
  wire [0:0]S00_AXI_0_wready;
  wire [15:0]S00_AXI_0_wstrb;
  wire [0:0]S00_AXI_0_wvalid;
  wire [8:0]S_AXI_LITE_0_araddr;
  wire S_AXI_LITE_0_arready;
  wire S_AXI_LITE_0_arvalid;
  wire [8:0]S_AXI_LITE_0_awaddr;
  wire S_AXI_LITE_0_awready;
  wire S_AXI_LITE_0_awvalid;
  wire S_AXI_LITE_0_bready;
  wire [1:0]S_AXI_LITE_0_bresp;
  wire S_AXI_LITE_0_bvalid;
  wire [31:0]S_AXI_LITE_0_rdata;
  wire S_AXI_LITE_0_rready;
  wire [1:0]S_AXI_LITE_0_rresp;
  wire S_AXI_LITE_0_rvalid;
  wire [31:0]S_AXI_LITE_0_wdata;
  wire S_AXI_LITE_0_wready;
  wire S_AXI_LITE_0_wvalid;
  wire aresetn;
  wire clk_100M;
  wire clk_locked;
  wire clk_pixel;
  wire clk_serial;
  wire [13:0]ddr3_sdram_addr;
  wire [2:0]ddr3_sdram_ba;
  wire ddr3_sdram_cas_n;
  wire [0:0]ddr3_sdram_ck_n;
  wire [0:0]ddr3_sdram_ck_p;
  wire [0:0]ddr3_sdram_cke;
  wire [0:0]ddr3_sdram_cs_n;
  wire [1:0]ddr3_sdram_dm;
  wire [15:0]ddr3_sdram_dq;
  wire [1:0]ddr3_sdram_dqs_n;
  wire [1:0]ddr3_sdram_dqs_p;
  wire [0:0]ddr3_sdram_odt;
  wire ddr3_sdram_ras_n;
  wire ddr3_sdram_reset_n;
  wire ddr3_sdram_we_n;
  wire init_calib_complete_0;
  wire mig_reset;
  wire mmcm_locked_0;
  wire sys_clk_i;
  wire vid_io_out_0_active_video;
  wire [23:0]vid_io_out_0_data;
  wire vid_io_out_0_field;
  wire vid_io_out_0_hblank;
  wire vid_io_out_0_hsync;
  wire vid_io_out_0_vblank;
  wire vid_io_out_0_vsync;

  memory memory_i
       (.GND(GND),
        .HIGH(HIGH),
        .S00_AXI_0_araddr(S00_AXI_0_araddr),
        .S00_AXI_0_arburst(S00_AXI_0_arburst),
        .S00_AXI_0_arcache(S00_AXI_0_arcache),
        .S00_AXI_0_arlen(S00_AXI_0_arlen),
        .S00_AXI_0_arlock(S00_AXI_0_arlock),
        .S00_AXI_0_arprot(S00_AXI_0_arprot),
        .S00_AXI_0_arqos(S00_AXI_0_arqos),
        .S00_AXI_0_arready(S00_AXI_0_arready),
        .S00_AXI_0_arregion(S00_AXI_0_arregion),
        .S00_AXI_0_arsize(S00_AXI_0_arsize),
        .S00_AXI_0_arvalid(S00_AXI_0_arvalid),
        .S00_AXI_0_awaddr(S00_AXI_0_awaddr),
        .S00_AXI_0_awburst(S00_AXI_0_awburst),
        .S00_AXI_0_awcache(S00_AXI_0_awcache),
        .S00_AXI_0_awlen(S00_AXI_0_awlen),
        .S00_AXI_0_awlock(S00_AXI_0_awlock),
        .S00_AXI_0_awprot(S00_AXI_0_awprot),
        .S00_AXI_0_awqos(S00_AXI_0_awqos),
        .S00_AXI_0_awready(S00_AXI_0_awready),
        .S00_AXI_0_awregion(S00_AXI_0_awregion),
        .S00_AXI_0_awsize(S00_AXI_0_awsize),
        .S00_AXI_0_awvalid(S00_AXI_0_awvalid),
        .S00_AXI_0_bready(S00_AXI_0_bready),
        .S00_AXI_0_bresp(S00_AXI_0_bresp),
        .S00_AXI_0_bvalid(S00_AXI_0_bvalid),
        .S00_AXI_0_rdata(S00_AXI_0_rdata),
        .S00_AXI_0_rlast(S00_AXI_0_rlast),
        .S00_AXI_0_rready(S00_AXI_0_rready),
        .S00_AXI_0_rresp(S00_AXI_0_rresp),
        .S00_AXI_0_rvalid(S00_AXI_0_rvalid),
        .S00_AXI_0_wdata(S00_AXI_0_wdata),
        .S00_AXI_0_wlast(S00_AXI_0_wlast),
        .S00_AXI_0_wready(S00_AXI_0_wready),
        .S00_AXI_0_wstrb(S00_AXI_0_wstrb),
        .S00_AXI_0_wvalid(S00_AXI_0_wvalid),
        .S_AXI_LITE_0_araddr(S_AXI_LITE_0_araddr),
        .S_AXI_LITE_0_arready(S_AXI_LITE_0_arready),
        .S_AXI_LITE_0_arvalid(S_AXI_LITE_0_arvalid),
        .S_AXI_LITE_0_awaddr(S_AXI_LITE_0_awaddr),
        .S_AXI_LITE_0_awready(S_AXI_LITE_0_awready),
        .S_AXI_LITE_0_awvalid(S_AXI_LITE_0_awvalid),
        .S_AXI_LITE_0_bready(S_AXI_LITE_0_bready),
        .S_AXI_LITE_0_bresp(S_AXI_LITE_0_bresp),
        .S_AXI_LITE_0_bvalid(S_AXI_LITE_0_bvalid),
        .S_AXI_LITE_0_rdata(S_AXI_LITE_0_rdata),
        .S_AXI_LITE_0_rready(S_AXI_LITE_0_rready),
        .S_AXI_LITE_0_rresp(S_AXI_LITE_0_rresp),
        .S_AXI_LITE_0_rvalid(S_AXI_LITE_0_rvalid),
        .S_AXI_LITE_0_wdata(S_AXI_LITE_0_wdata),
        .S_AXI_LITE_0_wready(S_AXI_LITE_0_wready),
        .S_AXI_LITE_0_wvalid(S_AXI_LITE_0_wvalid),
        .aresetn(aresetn),
        .clk_100M(clk_100M),
        .clk_locked(clk_locked),
        .clk_pixel(clk_pixel),
        .clk_serial(clk_serial),
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        .init_calib_complete_0(init_calib_complete_0),
        .mig_reset(mig_reset),
        .mmcm_locked_0(mmcm_locked_0),
        .sys_clk_i(sys_clk_i),
        .vid_io_out_0_active_video(vid_io_out_0_active_video),
        .vid_io_out_0_data(vid_io_out_0_data),
        .vid_io_out_0_field(vid_io_out_0_field),
        .vid_io_out_0_hblank(vid_io_out_0_hblank),
        .vid_io_out_0_hsync(vid_io_out_0_hsync),
        .vid_io_out_0_vblank(vid_io_out_0_vblank),
        .vid_io_out_0_vsync(vid_io_out_0_vsync));
endmodule
