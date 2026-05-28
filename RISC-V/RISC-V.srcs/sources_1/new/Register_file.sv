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
    input  logic nrst,
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

always_ff @(posedge clk or negedge nrst) begin

    if (!nrst) begin                  //not sure if this block is needed
        rs1_data <= '0;
        rs2_data <= '0;
    end
    else begin
        if (rd_en) begin
            rs1_data <= (rs1_addr == '0)? '0 : register[rs1_addr];
            rs2_data <= (rs2_addr == '0)? '0 : register[rs2_addr];
        end

    end
end

endmodule

