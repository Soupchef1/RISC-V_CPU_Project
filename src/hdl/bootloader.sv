`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2026 08:08:40 PM
// Design Name: 
// Module Name: bootloader
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


module bootloader(
        input logic clk, nrst,

        input logic uart_rx, mig_ready,
        output logic start_done, start_valid, start_write_en,
        output logic [31:0] start_addr, start_data,

        //signals to axi_ctrl
        input logic axi_ctrl_bvalid,
        output logic boot_start,

        output logic pkt_failed

    );

    logic rx_valid;
    logic [7:0] rx_data;

    logic [31:0] pkt_addr, pkt_data;
    logic pkt_ready, pkt_fail;
    logic boot_finish;

    uart_receiver receiver (
        .rx(uart_rx),
        .*
    );

    uart_packet_reader packet_reader (
        .addr(pkt_addr),
        .data(pkt_data),
        .*
    );

    startup_ctrl controller (
        .pkt_finish(boot_finish),
        .mig_calib_complete(mig_ready),
        .data(start_data),
        .addr(start_addr),
        .*
    );
endmodule
