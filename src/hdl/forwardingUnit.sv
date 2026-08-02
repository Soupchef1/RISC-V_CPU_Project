`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Trip Taylor - CEO/Co-Founder
// 
// Create Date: 06/28/2026 08:49:26 PM
// Design Name: 
// Module Name: forwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Needs testbench 
// 
//////////////////////////////////////////////////////////////////////////////////



// DEF = use value from register file
// EX = forward result from execute stage
// MEM = forward result from memory stage
typedef enum logic[3:0] { 
    RS1_DEF_RS2_DEF,
    RS1_DEF_RS2_EX,
    RS1_DEF_RS2_MEM,
    RS1_EX_RS2_DEF,
    RS1_EX_RS2_EX,
    RS1_EX_RS2_MEM,
    RS1_MEM_RS2_DEF,
    RS1_MEM_RS2_EX,
    RS1_MEM_RS2_MEM
} forwarding_setting_t;

module forwardingUnit(
    input logic [4:0] rs1_decode, //rd1
    input logic [4:0] rs2_decode, //rd2
    input logic [4:0] rd_ex,
    input logic [4:0] rd_mem,
    output forwarding_setting_t FUmux
    );

    always_comb begin 
        // forwarding logic
        FUmux = RS1_DEF_RS2_DEF; //default case

        // checking for matching register addresses
        if(rs1_decode == rd_ex && rd_ex != 0) begin
            if(rs2_decode == rd_ex && rd_ex != 0)begin
                FUmux = RS1_EX_RS2_EX;
            end
            else if(rs2_decode == rd_mem && rd_mem != 0)begin
                FUmux = RS1_EX_RS2_MEM;
            end
            else begin 
                FUmux = RS1_EX_RS2_DEF;
            end
        end
        else if(rs1_decode == rd_mem && rd_mem != 0) begin
            if(rs2_decode == rd_ex && rd_ex != 0)begin
                FUmux = RS1_MEM_RS2_EX;
            end
            else if(rs2_decode == rd_mem && rd_mem != 0 )begin
                FUmux = RS1_MEM_RS2_MEM;
            end
            else begin 
                FUmux = RS1_MEM_RS2_DEF;
            end
        end
        else begin
            if(rs2_decode == rd_ex && rd_ex != 0)begin
                FUmux = RS1_DEF_RS2_EX;
            end
            else if(rs2_decode == rd_mem && rd_mem != 0)begin
                FUmux = RS1_DEF_RS2_MEM;
            end
            else begin 
                FUmux = RS1_DEF_RS2_DEF;
            end
        end
    end
endmodule
