`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2026 05:42:30 PM
// Design Name: 
// Module Name: HDMI
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

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic [7:0] red;
    logic [7:0] blue;
    logic [7:0] green;

    assign red = vid_data[23:16];
    assign blue = vid_data[7:0];
    assign green = vid_data[15:8];

    logic [9:0] tmds_red, tmds_blue, tmds_green;

    logic oce;
    assign oce = nrst;

    TMDS_encoder encode_red (
        .pixel_clk(pixel_clk),
        .nrst(nrst),
        .vid_active(vid_active),
        .hsync(LOW),
        .vsync(LOW),
        .color(red),
        .tmds(tmds_red)
    );

    TMDS_encoder encode_blue (
        .pixel_clk(pixel_clk),
        .nrst(nrst),
        .vid_active(vid_active),
        .hsync(hsync),
        .vsync(vsync),
        .color(blue),
        .tmds(tmds_blue)
    );  

    TMDS_encoder encode_green (
        .pixel_clk(pixel_clk),
        .nrst(nrst),
        .vid_active(vid_active),
        .hsync(LOW),
        .vsync(LOW),
        .color(green),
        .tmds(tmds_green)
    );

    logic ser_red, ser_green, ser_blue, ser_clk; //output stream of data

    TMDS_serializer serialize_red (
        .pixel_clk(pixel_clk),
        .serial_clk(serial_clk),
        .nrst(nrst),
        .oce(oce),
        .tmds_data(tmds_red),
        .tmds_out(ser_red)
    );

    TMDS_serializer serialize_green (
        .pixel_clk(pixel_clk),
        .serial_clk(serial_clk),
        .nrst(nrst),
        .oce(oce),
        .tmds_data(tmds_green),
        .tmds_out(ser_green)
    );

    TMDS_serializer serialize_blue (
        .pixel_clk(pixel_clk),
        .serial_clk(serial_clk),
        .nrst(nrst),
        .oce(oce),
        .tmds_data(tmds_blue),
        .tmds_out(ser_blue)
    );

    TMDS_serializer serialize_clk (
        .pixel_clk(pixel_clk),
        .serial_clk(serial_clk),
        .nrst(nrst),
        .oce(oce),
        .tmds_data(10'b1111100000),
        .tmds_out(ser_clk)
    );

    //blue
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) OBUFDS_blue (
      .O(hdmi_out_p[0]),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_out_n[0]),   // Diff_n output (connect directly to top-level port)
      .I(ser_blue)      // Buffer input
    );

    //green
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) OBUFDS_green (
      .O(hdmi_out_p[1]),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_out_n[1]),   // Diff_n output (connect directly to top-level port)
      .I(ser_green)      // Buffer input
    );

    //red
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) OBUFDS_red (
      .O(hdmi_out_p[2]),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_out_n[2]),   // Diff_n output (connect directly to top-level port)
      .I(ser_red)      // Buffer input
    );

    //clk
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) OBUFDS_clk (
      .O(hdmi_out_clk_p),     // Diff_p output (connect directly to top-level port)
      .OB(hdmi_out_clk_n),   // Diff_n output (connect directly to top-level port)
      .I(ser_clk)      // Buffer input
    );
    

endmodule
