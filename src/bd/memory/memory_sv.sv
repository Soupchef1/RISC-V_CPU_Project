// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// DO NOT MODIFY THIS FILE.

// MODULE VLNV: amd.com:blockdesign:memory:1.0

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module memory_sv (
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI_0" *)
  (* X_INTERFACE_MODE = "slave S00_AXI_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_0, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 90012681, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
  vivado_aximm_v1_0.slave S00_AXI_0,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_LITE_0" *)
  (* X_INTERFACE_MODE = "slave S_AXI_LITE_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_LITE_0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 90012681, ID_WIDTH 0, ADDR_WIDTH 16, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 0, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
  vivado_axi4_lite_v1_0.slave S_AXI_LITE_0,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [15:0] ddr3_sdram_dq,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] ddr3_sdram_dqs_p,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] ddr3_sdram_dqs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [13:0] ddr3_sdram_addr,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [2:0] ddr3_sdram_ba,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr3_sdram_ras_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr3_sdram_cas_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr3_sdram_we_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr3_sdram_reset_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ddr3_sdram_ck_p,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ddr3_sdram_ck_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ddr3_sdram_cke,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ddr3_sdram_cs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [1:0] ddr3_sdram_dm,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] ddr3_sdram_odt,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_active_video,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [23:0] vid_io_out_0_data,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_field,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_hblank,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_hsync,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_vblank,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire vid_io_out_0_vsync,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sys_clk_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire init_calib_complete_0,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire mmcm_locked_0,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire GND,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire clk_100M,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire clk_pixel,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire clk_serial,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire clk_locked,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire mig_reset,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire HIGH,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire aresetn
);

  // interface wire assignments
  assign S00_AXI_0.BID = 0;
  assign S00_AXI_0.BUSER = 0;
  assign S00_AXI_0.RID = 0;
  assign S00_AXI_0.RUSER = 0;

  memory inst (
    .ddr3_sdram_dq(ddr3_sdram_dq),
    .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
    .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
    .ddr3_sdram_addr(ddr3_sdram_addr),
    .ddr3_sdram_ba(ddr3_sdram_ba),
    .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
    .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
    .ddr3_sdram_we_n(ddr3_sdram_we_n),
    .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
    .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
    .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
    .ddr3_sdram_cke(ddr3_sdram_cke),
    .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
    .ddr3_sdram_dm(ddr3_sdram_dm),
    .ddr3_sdram_odt(ddr3_sdram_odt),
    .vid_io_out_0_active_video(vid_io_out_0_active_video),
    .vid_io_out_0_data(vid_io_out_0_data),
    .vid_io_out_0_field(vid_io_out_0_field),
    .vid_io_out_0_hblank(vid_io_out_0_hblank),
    .vid_io_out_0_hsync(vid_io_out_0_hsync),
    .vid_io_out_0_vblank(vid_io_out_0_vblank),
    .vid_io_out_0_vsync(vid_io_out_0_vsync),
    .S00_AXI_0_awaddr(S00_AXI_0.AWADDR),
    .S00_AXI_0_awlen(S00_AXI_0.AWLEN),
    .S00_AXI_0_awsize(S00_AXI_0.AWSIZE),
    .S00_AXI_0_awburst(S00_AXI_0.AWBURST),
    .S00_AXI_0_awlock(S00_AXI_0.AWLOCK),
    .S00_AXI_0_awcache(S00_AXI_0.AWCACHE),
    .S00_AXI_0_awprot(S00_AXI_0.AWPROT),
    .S00_AXI_0_awqos(S00_AXI_0.AWQOS),
    .S00_AXI_0_awvalid(S00_AXI_0.AWVALID),
    .S00_AXI_0_awready(S00_AXI_0.AWREADY),
    .S00_AXI_0_wdata(S00_AXI_0.WDATA),
    .S00_AXI_0_wstrb(S00_AXI_0.WSTRB),
    .S00_AXI_0_wlast(S00_AXI_0.WLAST),
    .S00_AXI_0_wvalid(S00_AXI_0.WVALID),
    .S00_AXI_0_wready(S00_AXI_0.WREADY),
    .S00_AXI_0_bresp(S00_AXI_0.BRESP),
    .S00_AXI_0_bvalid(S00_AXI_0.BVALID),
    .S00_AXI_0_bready(S00_AXI_0.BREADY),
    .S00_AXI_0_araddr(S00_AXI_0.ARADDR),
    .S00_AXI_0_arlen(S00_AXI_0.ARLEN),
    .S00_AXI_0_arsize(S00_AXI_0.ARSIZE),
    .S00_AXI_0_arburst(S00_AXI_0.ARBURST),
    .S00_AXI_0_arlock(S00_AXI_0.ARLOCK),
    .S00_AXI_0_arcache(S00_AXI_0.ARCACHE),
    .S00_AXI_0_arprot(S00_AXI_0.ARPROT),
    .S00_AXI_0_arqos(S00_AXI_0.ARQOS),
    .S00_AXI_0_arvalid(S00_AXI_0.ARVALID),
    .S00_AXI_0_arready(S00_AXI_0.ARREADY),
    .S00_AXI_0_rdata(S00_AXI_0.RDATA),
    .S00_AXI_0_rresp(S00_AXI_0.RRESP),
    .S00_AXI_0_rlast(S00_AXI_0.RLAST),
    .S00_AXI_0_rvalid(S00_AXI_0.RVALID),
    .S00_AXI_0_rready(S00_AXI_0.RREADY),
    .S00_AXI_0_arregion(S00_AXI_0.ARREGION),
    .S00_AXI_0_awregion(S00_AXI_0.AWREGION),
    .S_AXI_LITE_0_araddr(S_AXI_LITE_0.ARADDR),
    .S_AXI_LITE_0_arready(S_AXI_LITE_0.ARREADY),
    .S_AXI_LITE_0_arvalid(S_AXI_LITE_0.ARVALID),
    .S_AXI_LITE_0_awaddr(S_AXI_LITE_0.AWADDR),
    .S_AXI_LITE_0_awready(S_AXI_LITE_0.AWREADY),
    .S_AXI_LITE_0_awvalid(S_AXI_LITE_0.AWVALID),
    .S_AXI_LITE_0_bready(S_AXI_LITE_0.BREADY),
    .S_AXI_LITE_0_bresp(S_AXI_LITE_0.BRESP),
    .S_AXI_LITE_0_bvalid(S_AXI_LITE_0.BVALID),
    .S_AXI_LITE_0_rdata(S_AXI_LITE_0.RDATA),
    .S_AXI_LITE_0_rready(S_AXI_LITE_0.RREADY),
    .S_AXI_LITE_0_rresp(S_AXI_LITE_0.RRESP),
    .S_AXI_LITE_0_rvalid(S_AXI_LITE_0.RVALID),
    .S_AXI_LITE_0_wdata(S_AXI_LITE_0.WDATA),
    .S_AXI_LITE_0_wready(S_AXI_LITE_0.WREADY),
    .S_AXI_LITE_0_wvalid(S_AXI_LITE_0.WVALID),
    .sys_clk_i(sys_clk_i),
    .init_calib_complete_0(init_calib_complete_0),
    .mmcm_locked_0(mmcm_locked_0),
    .GND(GND),
    .clk_100M(clk_100M),
    .clk_pixel(clk_pixel),
    .clk_serial(clk_serial),
    .clk_locked(clk_locked),
    .mig_reset(mig_reset),
    .HIGH(HIGH),
    .aresetn(aresetn)
  );

endmodule
