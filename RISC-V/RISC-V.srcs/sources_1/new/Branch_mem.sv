`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: RYan
// 
// Create Date: 06/24/2026 07:52:08 PM
// Design Name: Branch memory
// Module Name: Branch_mem
// Project Name: GOON-PU
// Target Devices: FPGA
// Tool Versions: VIVADO
// Description: yurr
// 
// Dependencies: try finger but hole
// 
// Revision: 5^96
// Revision 0.01 - File Created
// Additional Comments: Ben please make sure ts is right idk what I wrote
// 
//////////////////////////////////////////////////////////////////////////////////


module Branch_mem(

    input logic clk, nrst, flush,
    
    input logic [31:0] pc_in, //pc from IF stage
    input logic [31:0] pc_d, //pc of branch instruction in execute stage
    input logic [31:0] target, //from ex_stage

    input logic [4:0] MUX_en, //straight from decode stage
    input logic pc_switch, //from execute stage

    output logic [1:0] bht,
    output logic [31:0] branch_addr
    
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    logic ena, enb;
    logic [6:0] wea;
    logic [9:0] addra, addrb;
    logic [55:0] dina, doutb;
    logic [55:0] target_data;

    assign enb = HIGH;
    assign wea = '1;
    assign addra = pc_d[11:2];
    assign addrb = pc_in[11:2];
    assign branch_addr = doutb[31:0];
    assign bht = (doutb[34] & tag_match) ? doutb[33:32] : 2'b00;  //just checks valid bit also so we nevr take if valid bit is zero
    assign dina = target_data;

    logic [19:0] pc_tag;
    logic [19:0] branch_tag;
    logic [55:0] branch_data;
    logic [55:0] branch_data_ex;
    logic branch_en;
    logic branch_en_ex;


    assign branch_en = MUX_en[3];
    assign branch_data = doutb;
    assign branch_tag = doutb[54:35];
    
    logic tag_match;
    logic tag_match_ex;
    assign tag_match = (pc_tag == branch_tag);

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst | flush) begin
            pc_tag <= '0;
            branch_data_ex <= '0;
            tag_match_ex <= '0;
            branch_en_ex <= '0;
        end
        else if (stall) begin
            pc_tag <= pc_tag;
            branch_data_ex <= branch_data_ex;
            tag_match_ex <= tag_match_ex;
            branch_en_ex <= branch_en_ex;
        end
        else begin 
            pc_tag <= pc_in[31:12];
            //piplined cache line for a certain intruction so we can write back
            branch_data_ex <= branch_data;
            // pipelined checks
            tag_match_ex <= tag_match;
            branch_en_ex <= branch_en;
        end
    end

//write logic
    always_comb begin
        //TODO: idk what to do for reset or startup
        if(!tag_match_ex & branch_en_ex & pc_switch) begin
            //write with bht as 10
            ena = HIGH;
            target_data = {1'b0, pc_d[31:12], 1'b1, 2'b10, target};
        end
        else if(tag_match_ex & branch_en_ex) begin
            //write depending on pc_switch
            case (pc_switch)
                HIGH: begin
                    ena = HIGH;
                    target_data = {1'b0, pc_d[31:12], 1'b1, (branch_data_ex[33:32] == 2'b11) ? 2'b11 : branch_data_ex[33:32] + 2'b01, target};
                end
                LOW: begin
                    ena = HIGH;
                    target_data = {1'b0, pc_d[31:12], 1'b1, (branch_data_ex[33:32] == 2'b00) ? 2'b00 : branch_data_ex[33:32] - 2'b01, target};
                end
            endcase
        end
        else begin
            //dont write
            ena = LOW;
            target_data = '0;
        end
    end

    //write logic
    // pc_tag = branch_tag => send out through pipeline as tag_match signal
    // if tag_match is low and branch_en high and pc_switch is high, write and set bht to 10
    // else if tag_match is high and branch_en is high, write and +1 or -1 depending on pc_switch
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
