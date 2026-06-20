`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Goon LLC
// Engineer: hard r
// 
// Create Date: 06/20/2026 12:01:30 PM
// Design Name: 
// Module Name: WB_top
// Project Name: GOON_PU
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: finger
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WB_top(

    input logic clk,
    input logic nrst,
    input logic [31:0] ALU_out,
    input logic [4:0] rd,
    input logic stall,

    output logic [31:0] ALU_outmem,
    output logic [4:0] rd_mem

    );

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) begin
            rd_mem <= '0;
            ALU_outmem <= '0;
        end
        else if (stall) begin
            rd_mem <= rd_mem;
            ALU_outmem <= ALU_outmem;
        end
        else begin
            rd_mem <= rd;
            ALU_outmem <= ALU_out;
        end
    end 

endmodule
