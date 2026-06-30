// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Tue Jun 23 23:00:23 2026
// Host        : DESKTOP-M886FGP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_1_sim_netlist.v
// Design      : blk_mem_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_1,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_12 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 49568)
`pragma protect data_block
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
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
