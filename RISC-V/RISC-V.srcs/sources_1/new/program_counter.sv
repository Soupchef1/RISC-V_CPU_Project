`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2026 09:11:26 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(

    input logic clk, nrst,
    input logic flush, stall,
    input logic [1:0] bht, //BHT 2-bit from branch memory
    input logic [4:0] MUX_en,
    input logic [31:0] PC_next, //from ex stage
    input logic [31:0] branch_addr, //from branch memory

    output logic [31:0] PC_in, //to pipeline reg and branch memory
    output logic pred_j //predicted jump signal to controller

    );

    logic take;  //signal for mux after pc register
    assign take = (bht[1] & MUX_en[3]);

    logic [31:0] pc_reg;
    logic [31:0] pc;
    logic [31:0] pc_internal; //internal wire connected to PC_in

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            pc <= '0; 
        end  
        else if (flush) begin
            pc <= PC_next;
        end
        else if (stall) begin
            pc <= pc;
        end
        else begin
            pc <= pc_internal + 4;
        end
    end

    assign pc_internal = (take) ? branch_addr : pc;
    assign PC_in = pc_internal;
    assign pred_j = take;
endmodule
