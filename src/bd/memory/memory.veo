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

// The following must be inserted into your Verilog file for this
// module to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

// INST_TAG     ------ Begin cut for INSTANTIATION Template ------
memory your_instance_name (
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
  .S00_AXI_0_awaddr(S00_AXI_0_awaddr), // input wire [31:0] S00_AXI_0_awaddr
  .S00_AXI_0_awlen(S00_AXI_0_awlen), // input wire [7:0] S00_AXI_0_awlen
  .S00_AXI_0_awsize(S00_AXI_0_awsize), // input wire [2:0] S00_AXI_0_awsize
  .S00_AXI_0_awburst(S00_AXI_0_awburst), // input wire [1:0] S00_AXI_0_awburst
  .S00_AXI_0_awlock(S00_AXI_0_awlock), // input wire [0:0] S00_AXI_0_awlock
  .S00_AXI_0_awcache(S00_AXI_0_awcache), // input wire [3:0] S00_AXI_0_awcache
  .S00_AXI_0_awprot(S00_AXI_0_awprot), // input wire [2:0] S00_AXI_0_awprot
  .S00_AXI_0_awqos(S00_AXI_0_awqos), // input wire [3:0] S00_AXI_0_awqos
  .S00_AXI_0_awvalid(S00_AXI_0_awvalid), // input wire S00_AXI_0_awvalid
  .S00_AXI_0_awready(S00_AXI_0_awready), // output wire S00_AXI_0_awready
  .S00_AXI_0_wdata(S00_AXI_0_wdata), // input wire [31:0] S00_AXI_0_wdata
  .S00_AXI_0_wstrb(S00_AXI_0_wstrb), // input wire [3:0] S00_AXI_0_wstrb
  .S00_AXI_0_wlast(S00_AXI_0_wlast), // input wire S00_AXI_0_wlast
  .S00_AXI_0_wvalid(S00_AXI_0_wvalid), // input wire S00_AXI_0_wvalid
  .S00_AXI_0_wready(S00_AXI_0_wready), // output wire S00_AXI_0_wready
  .S00_AXI_0_bresp(S00_AXI_0_bresp), // output wire [1:0] S00_AXI_0_bresp
  .S00_AXI_0_bvalid(S00_AXI_0_bvalid), // output wire S00_AXI_0_bvalid
  .S00_AXI_0_bready(S00_AXI_0_bready), // input wire S00_AXI_0_bready
  .S00_AXI_0_araddr(S00_AXI_0_araddr), // input wire [31:0] S00_AXI_0_araddr
  .S00_AXI_0_arlen(S00_AXI_0_arlen), // input wire [7:0] S00_AXI_0_arlen
  .S00_AXI_0_arsize(S00_AXI_0_arsize), // input wire [2:0] S00_AXI_0_arsize
  .S00_AXI_0_arburst(S00_AXI_0_arburst), // input wire [1:0] S00_AXI_0_arburst
  .S00_AXI_0_arlock(S00_AXI_0_arlock), // input wire [0:0] S00_AXI_0_arlock
  .S00_AXI_0_arcache(S00_AXI_0_arcache), // input wire [3:0] S00_AXI_0_arcache
  .S00_AXI_0_arprot(S00_AXI_0_arprot), // input wire [2:0] S00_AXI_0_arprot
  .S00_AXI_0_arqos(S00_AXI_0_arqos), // input wire [3:0] S00_AXI_0_arqos
  .S00_AXI_0_arvalid(S00_AXI_0_arvalid), // input wire S00_AXI_0_arvalid
  .S00_AXI_0_arready(S00_AXI_0_arready), // output wire S00_AXI_0_arready
  .S00_AXI_0_rdata(S00_AXI_0_rdata), // output wire [31:0] S00_AXI_0_rdata
  .S00_AXI_0_rresp(S00_AXI_0_rresp), // output wire [1:0] S00_AXI_0_rresp
  .S00_AXI_0_rlast(S00_AXI_0_rlast), // output wire S00_AXI_0_rlast
  .S00_AXI_0_rvalid(S00_AXI_0_rvalid), // output wire S00_AXI_0_rvalid
  .S00_AXI_0_rready(S00_AXI_0_rready), // input wire S00_AXI_0_rready
  .S_AXI_LITE_0_araddr(S_AXI_LITE_0_araddr), // input wire [8:0] S_AXI_LITE_0_araddr
  .S_AXI_LITE_0_arready(S_AXI_LITE_0_arready), // output wire S_AXI_LITE_0_arready
  .S_AXI_LITE_0_arvalid(S_AXI_LITE_0_arvalid), // input wire S_AXI_LITE_0_arvalid
  .S_AXI_LITE_0_awaddr(S_AXI_LITE_0_awaddr), // input wire [8:0] S_AXI_LITE_0_awaddr
  .S_AXI_LITE_0_awready(S_AXI_LITE_0_awready), // output wire S_AXI_LITE_0_awready
  .S_AXI_LITE_0_awvalid(S_AXI_LITE_0_awvalid), // input wire S_AXI_LITE_0_awvalid
  .S_AXI_LITE_0_bready(S_AXI_LITE_0_bready), // input wire S_AXI_LITE_0_bready
  .S_AXI_LITE_0_bresp(S_AXI_LITE_0_bresp), // output wire [1:0] S_AXI_LITE_0_bresp
  .S_AXI_LITE_0_bvalid(S_AXI_LITE_0_bvalid), // output wire S_AXI_LITE_0_bvalid
  .S_AXI_LITE_0_rdata(S_AXI_LITE_0_rdata), // output wire [31:0] S_AXI_LITE_0_rdata
  .S_AXI_LITE_0_rready(S_AXI_LITE_0_rready), // input wire S_AXI_LITE_0_rready
  .S_AXI_LITE_0_rresp(S_AXI_LITE_0_rresp), // output wire [1:0] S_AXI_LITE_0_rresp
  .S_AXI_LITE_0_rvalid(S_AXI_LITE_0_rvalid), // output wire S_AXI_LITE_0_rvalid
  .S_AXI_LITE_0_wdata(S_AXI_LITE_0_wdata), // input wire [31:0] S_AXI_LITE_0_wdata
  .S_AXI_LITE_0_wready(S_AXI_LITE_0_wready), // output wire S_AXI_LITE_0_wready
  .S_AXI_LITE_0_wvalid(S_AXI_LITE_0_wvalid), // input wire S_AXI_LITE_0_wvalid
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
// INST_TAG_END ------  End cut for INSTANTIATION Template  ------

// You must compile the wrapper file memory.v when simulating
// the module, memory. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.
