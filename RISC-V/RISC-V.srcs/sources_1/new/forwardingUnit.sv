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


module forwardingUnit(
    input logic clk,
    input logic nrst,
    input logic [4:0] rs1_decode,
    input logic [4:0] rs2_decode,
    input logic [4:0] rd_ex,
    input logic [4:0] rd_mem,
    input logic flush,
    input logic stall,
    output logic [3:0] FUmux
    );

    always_ff @(posedge clk, negedge nrst) begin
        //reset and flush logic
        if(!nrst | flush) begin
            FUmux <= '0;
        end

        else if(stall) begin
            FUmux <= FUmux;
        end

        else begin
            if(rs2_decode == rd_ex) begin
                if(rs1_decode == rd_ex)begin
                    FUmux <= 4'd4;
                end

                else if(rs1_decode == rd_mem)begin
                    FUmux <= 4'd7;
                end

                else begin //rs1 cannot be forwarded
                    FUmux <= 4'd1;
                end
                
            end
            
            else if(rs2_decode == rd_mem) begin
                if(rs1_decode == rd_ex)begin
                    FUmux <= 4'd5;
                end

                else if(rs1_decode == rd_mem)begin
                    FUmux <= 4'd8;
                end

                else begin //rs1 cannot be forwarded
                    FUmux <= 4'd2;
                end
                
            end
            // rs2 cannot be forwarded
            else begin
                if(rs1_decode == rd_ex)begin
                    FUmux <= 4'd3;
                end

                else if(rs1_decode == rd_mem)begin
                    FUmux <= 4'd6;
                end

                else begin //rs1 cannot be forwarded
                    FUmux <= 4'd0;
                end
            end
        end
    end
endmodule