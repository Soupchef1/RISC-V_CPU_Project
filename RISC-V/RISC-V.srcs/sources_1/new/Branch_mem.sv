`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2026 07:52:08 PM
// Design Name: 
// Module Name: Branch_mem
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


module Branch_mem(

    input logic clk, nrst,

    input logic [31:0] pc_in, 
    input logic [31:0] pc_d,
    input logic [31:0] target,

    input logic [4:0] MUX_en,
    input logic pc_switch,

    output logic [1:0] bht,
    output logic [31:0] branch_addr,
    input logic [55:0] ex_branch_data, //cache line for intruction in execute stage
    output logic [55:0] branch_data //data to get pipleined tag + bht (whole line)

    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena, enb;
    logic [6:0] wea;
    logic [9:0] addra, addrb;
    logic [55:0] dina, doutb;

    assign enb = HIGH;
    assign wea = '1;
    assign addra = pc_d[11:2];
    assign addrb = pc_in[11:2];
    assign branch_addr = doutb[31:0];
    assign bht = (doutb[34]) ? 2'b00 : doutb[33:32];
    assign dina = target_data;
    assign branch_data = doutb;

    logic [19:0] pc_tag;
    logic [19:0] branch_tag;

    assign branch_tag = doutb[54:35];
     
    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
        //idk
        end
        else begin 
            pc_tag <= pc_in[54:35];
        end
    end

    logic [55:0] target_data;

    //write logic
    // pc_tag = branch_tag => send out through pipeline as check signal
    // if check is low and branch_en high and pc_switch is high, write and set bht to 10
    // else if check is high and branch_en is high, write and +1 or -1 depending on pc_switch
    // else don't write



blk_mem_gen_1_sv Trip_balls_theorem (
  .clka(clk), // input wire clka
  .ena(ena), // input wire ena
  .wea(wea), // input wire [6:0] wea
  .addra(addra), // input wire [9:0] addra
  .dina(dina), // input wire [55:0] dina
  .clkb(clk), // input wire clkb
  .enb(enb), // input wire enb
  .addrb(addrb), // input wire [9:0] addrb
  .doutb(doutb) // output wire [55:0] doutb
);

endmodule
