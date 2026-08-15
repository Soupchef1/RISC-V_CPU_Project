-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- -------------------------------------------------------------------------------
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-- DO NOT MODIFY THIS FILE.

-- MODULE VLNV: amd.com:blockdesign:memory:1.0

-- The following code must appear in the VHDL architecture header.

-- COMP_TAG     ------ Begin cut for COMPONENT Declaration ------
COMPONENT memory
  PORT (
    ddr3_sdram_dq : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    ddr3_sdram_dqs_p : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ddr3_sdram_dqs_n : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ddr3_sdram_addr : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
    ddr3_sdram_ba : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ddr3_sdram_ras_n : OUT STD_LOGIC;
    ddr3_sdram_cas_n : OUT STD_LOGIC;
    ddr3_sdram_we_n : OUT STD_LOGIC;
    ddr3_sdram_reset_n : OUT STD_LOGIC;
    ddr3_sdram_ck_p : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr3_sdram_ck_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr3_sdram_cke : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr3_sdram_cs_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr3_sdram_dm : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ddr3_sdram_odt : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    vid_io_out_0_active_video : OUT STD_LOGIC;
    vid_io_out_0_data : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    vid_io_out_0_field : OUT STD_LOGIC;
    vid_io_out_0_hblank : OUT STD_LOGIC;
    vid_io_out_0_hsync : OUT STD_LOGIC;
    vid_io_out_0_vblank : OUT STD_LOGIC;
    vid_io_out_0_vsync : OUT STD_LOGIC;
    S00_AXI_0_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_0_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXI_0_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_0_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_0_awlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_0_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_0_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_0_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_0_awvalid : IN STD_LOGIC;
    S00_AXI_0_awready : OUT STD_LOGIC;
    S00_AXI_0_wdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    S00_AXI_0_wstrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    S00_AXI_0_wlast : IN STD_LOGIC;
    S00_AXI_0_wvalid : IN STD_LOGIC;
    S00_AXI_0_wready : OUT STD_LOGIC;
    S00_AXI_0_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_0_bvalid : OUT STD_LOGIC;
    S00_AXI_0_bready : IN STD_LOGIC;
    S00_AXI_0_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S00_AXI_0_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    S00_AXI_0_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_0_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_0_arlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    S00_AXI_0_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_0_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    S00_AXI_0_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_0_arvalid : IN STD_LOGIC;
    S00_AXI_0_arready : OUT STD_LOGIC;
    S00_AXI_0_rdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    S00_AXI_0_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S00_AXI_0_rlast : OUT STD_LOGIC;
    S00_AXI_0_rvalid : OUT STD_LOGIC;
    S00_AXI_0_rready : IN STD_LOGIC;
    S00_AXI_0_arregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S00_AXI_0_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_LITE_0_araddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    S_AXI_LITE_0_arready : OUT STD_LOGIC;
    S_AXI_LITE_0_arvalid : IN STD_LOGIC;
    S_AXI_LITE_0_awaddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    S_AXI_LITE_0_awready : OUT STD_LOGIC;
    S_AXI_LITE_0_awvalid : IN STD_LOGIC;
    S_AXI_LITE_0_bready : IN STD_LOGIC;
    S_AXI_LITE_0_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_LITE_0_bvalid : OUT STD_LOGIC;
    S_AXI_LITE_0_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_LITE_0_rready : IN STD_LOGIC;
    S_AXI_LITE_0_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_LITE_0_rvalid : OUT STD_LOGIC;
    S_AXI_LITE_0_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_LITE_0_wready : OUT STD_LOGIC;
    S_AXI_LITE_0_wvalid : IN STD_LOGIC;
    sys_clk_i : IN STD_LOGIC;
    init_calib_complete_0 : OUT STD_LOGIC;
    mmcm_locked_0 : OUT STD_LOGIC;
    GND : IN STD_LOGIC;
    clk_100M : OUT STD_LOGIC;
    clk_pixel : OUT STD_LOGIC;
    clk_serial : OUT STD_LOGIC;
    clk_locked : OUT STD_LOGIC;
    mig_reset : IN STD_LOGIC;
    HIGH : IN STD_LOGIC;
    aresetn : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------  End cut for COMPONENT Declaration  ------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

-- INST_TAG     ------ Begin cut for INSTANTIATION Template ------
your_instance_name : memory
  PORT MAP (
    ddr3_sdram_dq => ddr3_sdram_dq,
    ddr3_sdram_dqs_p => ddr3_sdram_dqs_p,
    ddr3_sdram_dqs_n => ddr3_sdram_dqs_n,
    ddr3_sdram_addr => ddr3_sdram_addr,
    ddr3_sdram_ba => ddr3_sdram_ba,
    ddr3_sdram_ras_n => ddr3_sdram_ras_n,
    ddr3_sdram_cas_n => ddr3_sdram_cas_n,
    ddr3_sdram_we_n => ddr3_sdram_we_n,
    ddr3_sdram_reset_n => ddr3_sdram_reset_n,
    ddr3_sdram_ck_p => ddr3_sdram_ck_p,
    ddr3_sdram_ck_n => ddr3_sdram_ck_n,
    ddr3_sdram_cke => ddr3_sdram_cke,
    ddr3_sdram_cs_n => ddr3_sdram_cs_n,
    ddr3_sdram_dm => ddr3_sdram_dm,
    ddr3_sdram_odt => ddr3_sdram_odt,
    vid_io_out_0_active_video => vid_io_out_0_active_video,
    vid_io_out_0_data => vid_io_out_0_data,
    vid_io_out_0_field => vid_io_out_0_field,
    vid_io_out_0_hblank => vid_io_out_0_hblank,
    vid_io_out_0_hsync => vid_io_out_0_hsync,
    vid_io_out_0_vblank => vid_io_out_0_vblank,
    vid_io_out_0_vsync => vid_io_out_0_vsync,
    S00_AXI_0_awaddr => S00_AXI_0_awaddr,
    S00_AXI_0_awlen => S00_AXI_0_awlen,
    S00_AXI_0_awsize => S00_AXI_0_awsize,
    S00_AXI_0_awburst => S00_AXI_0_awburst,
    S00_AXI_0_awlock => S00_AXI_0_awlock,
    S00_AXI_0_awcache => S00_AXI_0_awcache,
    S00_AXI_0_awprot => S00_AXI_0_awprot,
    S00_AXI_0_awqos => S00_AXI_0_awqos,
    S00_AXI_0_awvalid => S00_AXI_0_awvalid,
    S00_AXI_0_awready => S00_AXI_0_awready,
    S00_AXI_0_wdata => S00_AXI_0_wdata,
    S00_AXI_0_wstrb => S00_AXI_0_wstrb,
    S00_AXI_0_wlast => S00_AXI_0_wlast,
    S00_AXI_0_wvalid => S00_AXI_0_wvalid,
    S00_AXI_0_wready => S00_AXI_0_wready,
    S00_AXI_0_bresp => S00_AXI_0_bresp,
    S00_AXI_0_bvalid => S00_AXI_0_bvalid,
    S00_AXI_0_bready => S00_AXI_0_bready,
    S00_AXI_0_araddr => S00_AXI_0_araddr,
    S00_AXI_0_arlen => S00_AXI_0_arlen,
    S00_AXI_0_arsize => S00_AXI_0_arsize,
    S00_AXI_0_arburst => S00_AXI_0_arburst,
    S00_AXI_0_arlock => S00_AXI_0_arlock,
    S00_AXI_0_arcache => S00_AXI_0_arcache,
    S00_AXI_0_arprot => S00_AXI_0_arprot,
    S00_AXI_0_arqos => S00_AXI_0_arqos,
    S00_AXI_0_arvalid => S00_AXI_0_arvalid,
    S00_AXI_0_arready => S00_AXI_0_arready,
    S00_AXI_0_rdata => S00_AXI_0_rdata,
    S00_AXI_0_rresp => S00_AXI_0_rresp,
    S00_AXI_0_rlast => S00_AXI_0_rlast,
    S00_AXI_0_rvalid => S00_AXI_0_rvalid,
    S00_AXI_0_rready => S00_AXI_0_rready,
    S00_AXI_0_arregion => S00_AXI_0_arregion,
    S00_AXI_0_awregion => S00_AXI_0_awregion,
    S_AXI_LITE_0_araddr => S_AXI_LITE_0_araddr,
    S_AXI_LITE_0_arready => S_AXI_LITE_0_arready,
    S_AXI_LITE_0_arvalid => S_AXI_LITE_0_arvalid,
    S_AXI_LITE_0_awaddr => S_AXI_LITE_0_awaddr,
    S_AXI_LITE_0_awready => S_AXI_LITE_0_awready,
    S_AXI_LITE_0_awvalid => S_AXI_LITE_0_awvalid,
    S_AXI_LITE_0_bready => S_AXI_LITE_0_bready,
    S_AXI_LITE_0_bresp => S_AXI_LITE_0_bresp,
    S_AXI_LITE_0_bvalid => S_AXI_LITE_0_bvalid,
    S_AXI_LITE_0_rdata => S_AXI_LITE_0_rdata,
    S_AXI_LITE_0_rready => S_AXI_LITE_0_rready,
    S_AXI_LITE_0_rresp => S_AXI_LITE_0_rresp,
    S_AXI_LITE_0_rvalid => S_AXI_LITE_0_rvalid,
    S_AXI_LITE_0_wdata => S_AXI_LITE_0_wdata,
    S_AXI_LITE_0_wready => S_AXI_LITE_0_wready,
    S_AXI_LITE_0_wvalid => S_AXI_LITE_0_wvalid,
    sys_clk_i => sys_clk_i,
    init_calib_complete_0 => init_calib_complete_0,
    mmcm_locked_0 => mmcm_locked_0,
    GND => GND,
    clk_100M => clk_100M,
    clk_pixel => clk_pixel,
    clk_serial => clk_serial,
    clk_locked => clk_locked,
    mig_reset => mig_reset,
    HIGH => HIGH,
    aresetn => aresetn
  );
-- INST_TAG_END ------  End cut for INSTANTIATION Template  ------

-- You must compile the wrapper file memory.vhd when simulating
-- the module, memory. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.
