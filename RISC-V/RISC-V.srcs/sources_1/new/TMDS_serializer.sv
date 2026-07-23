`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ryan
// 
// Create Date: 07/22/2026 12:47:30 PM
// Design Name: 
// Module Name: TMDS_serializer
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


module TMDS_serializer(
    input  logic pixel_clk,  // Parallel clock (1x, e.g., 74.25 MHz)
    input  logic serial_clk, // High-speed serial clock (5x, e.g., 371.25 MHz)
    input  logic nrst,       // Asynchronous active-low reset
    input  logic oce,        // Output clock enable (usually 1'b1)
    input  logic [9:0] tmds_data,  // 10-bit TMDS 
    output logic tmds_out    // 1-bit serialized output to OBUFDS
);

logic shifted_tmds_8, shifted_tmds_9;

//MASTER
   OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("MASTER"), // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when RST is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when RST is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   )
   OSERDESE2_master (
      .OFB(),             // 1-bit output: Feedback path for data
      .OQ(tmds_out),               // 1-bit output: Data path output
      // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      .SHIFTOUT1(),
      .SHIFTOUT2(),
      .TBYTEOUT(),   // 1-bit output: Byte group tristate
      .TFB(),             // 1-bit output: 3-state control
      .TQ(),               // 1-bit output: 3-state control
      .CLK(serial_clk),             // 1-bit input: High speed clock
      .CLKDIV(pixel_clk),       // 1-bit input: Divided clock
      // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(tmds_data[0]),
      .D2(tmds_data[1]),
      .D3(tmds_data[2]),
      .D4(tmds_data[3]),
      .D5(tmds_data[4]),
      .D6(tmds_data[5]),
      .D7(tmds_data[6]),
      .D8(tmds_data[7]),
      .OCE(oce),             // 1-bit input: Output data clock enable
      .RST(~nrst),             // 1-bit input: Reset
      // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      .SHIFTIN1(shifted_tmds_8),
      .SHIFTIN2(shifted_tmds_9),
      // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
      .TCE(1'b0)          // 1-bit input: 3-state clock enable
   );

   //SLAVE
   OSERDESE2 #(
      .DATA_RATE_OQ("DDR"),   // DDR, SDR
      .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
      .DATA_WIDTH(10),         // Parallel data width (2-8,10,14)
      .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
      .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
      .SERDES_MODE("SLAVE"), // MASTER, SLAVE
      .SRVAL_OQ(1'b0),        // OQ output value when RST is used (1'b0,1'b1)
      .SRVAL_TQ(1'b0),        // TQ output value when RST is used (1'b0,1'b1)
      .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
      .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
      .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
   )
   OSERDESE2_slave (
      .OFB(),             // 1-bit output: Feedback path for data
      .OQ(),               // 1-bit output: Data path output
      // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
      .SHIFTOUT1(shifted_tmds_8),
      .SHIFTOUT2(shifted_tmds_9),
      .TBYTEOUT(),   // 1-bit output: Byte group tristate
      .TFB(),             // 1-bit output: 3-state control
      .TQ(),               // 1-bit output: 3-state control
      .CLK(serial_clk),             // 1-bit input: High speed clock
      .CLKDIV(pixel_clk),       // 1-bit input: Divided clock
      // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
      .D1(1'b0),
      .D2(1'b0),
      .D3(tmds_data[8]),
      .D4(tmds_data[9]),
      .D5(1'b0),
      .D6(1'b0),
      .D7(1'b0),
      .D8(1'b0),
      .OCE(oce),             // 1-bit input: Output data clock enable
      .RST(~nrst),             // 1-bit input: Reset
      // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
      .SHIFTIN1(1'b0),
      .SHIFTIN2(1'b0),
      // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
      .T1(1'b0),
      .T2(1'b0),
      .T3(1'b0),
      .T4(1'b0),
      .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
      .TCE(1'b0)          // 1-bit input: 3-state clock enable
   );  

endmodule
