`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 10:00:06 PM
// Design Name: 
// Module Name: Register_file
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


module Register_file #(

    parameter DATA_width = 32,
    parameter ADDR_width = 5
)(

    input  logic clk,
    input  logic [ADDR_width-1:0] rs1_addr,
    input  logic [ADDR_width-1:0] rs2_addr,
    input  logic [ADDR_width-1:0] write_addr,
    input  logic [DATA_width-1:0] write_data,
    input  logic rd_en,
    input  logic w_en,
    output logic [DATA_width-1:0] rs1_data,
    output logic [DATA_width-1:0] rs2_data

);

logic [DATA_width-1:0] register [0:31];    //creating the actual registers


//write logic

always_ff @(posedge clk) begin
    if (w_en) begin
        register[write_addr] <= (write_addr == '0)? '0 : write_data;
    end

end


//read logic

always_comb begin
        if (rs1_addr == '0) begin
            rs1_data = '0;                      
        end 
        else if ((rs1_addr == write_addr) && w_en) begin
            rs1_data = write_data;              // RAW Hazard Bypass: Forward new data
        end 
        else begin
            rs1_data = register[rs1_addr];      // Normal read
        end

        if (rs2_addr == '0) begin
            rs2_data = '0;                      
        end 
        else if ((rs2_addr == write_addr) && w_en) begin
            rs2_data = write_data;              // RAW Hazard Bypass: Forward new data
        end 
        else begin
            rs2_data = register[rs2_addr];      // Normal read
        end
    end

endmodule

