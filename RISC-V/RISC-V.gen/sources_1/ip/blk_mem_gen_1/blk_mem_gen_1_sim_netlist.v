// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Jun 23 23:00:24 2026
// Host        : DESKTOP-M886FGP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/felix/RISC-V_CPU_Project/RISC-V/RISC-V.gen/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_1
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [6:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [55:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [55:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [55:0]dina;
  wire [55:0]doutb;
  wire ena;
  wire enb;
  wire [6:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [55:0]NLW_U0_douta_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [55:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.9115 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_1.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "56" *) 
  (* C_READ_WIDTH_B = "56" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "7" *) 
  (* C_WEB_WIDTH = "7" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "56" *) 
  (* C_WRITE_WIDTH_B = "56" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_1_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[55:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[55:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 49440)
`pragma protect data_block
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
+7jewAl/a2flxWKQG8qHXXVcuLi+
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
