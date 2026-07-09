`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2026 12:51:51 AM
// Design Name: 
// Module Name: MEM_TOP_tb
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


module MEM_TOP_tb(
    );

    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    logic clk, nrst, flush, stall;

    logic [4:0] EX_rd;
    logic [31:0] EX_addr;
    logic [31:0] EX_data;
    logic [1:0] EX_mem_bytes, MA_mem_bytes; //#bytes to write: 00 for 0 bytes, 01 for 1 byte, 10 for 2 bytes, 11 for 4 bytes;
    logic mem_zero_extend;
    
    //controller signals
    logic EX_rd_en, EX_wr_en, MA_rd_en, MA_wr_en;
    logic stall_out;

    //mem controller signals
    logic ddr_rd_done;
    logic [511:0] ddr_data_in;
    logic ddr_rd_miss;
    logic ddr_wr_miss;
    logic [511:0] ddr_data_out;
    logic [31:0] ddr_addr;
    logic ddr_dirty;
    logic is_video_data;

    logic [31:0] MUX_data_out;
    logic mem_rd;

    MEM_TOP DUT (.*);

    task reset_dut;
    begin
        // Activate the reset
        nrst = 1'b0;
        @(posedge clk);
        @(posedge clk);
        // deactivate reset
        nrst = 1'b1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    // test bench signals
    string test_case;
    int test_num;
    int tests_passed;

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end

    assign stall = stall_out;

    initial begin
        
    end


endmodule
