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
    logic [4:0] mem_rd;

    logic [31:0] start_addr;
    logic start_done;

    MEM_TOP DUT (
        .clk(clk),
        .nrst(nrst),
        .EX_addr(EX_addr),
        .EX_data(EX_data),
        .EX_mem_bytes(EX_mem_bytes),
        .MA_mem_bytes(MA_mem_bytes),
        .mem_zero_extend(mem_zero_extend),
        .EX_rd_en(EX_rd_en),
        .EX_wr_en(EX_wr_en),
        .MA_rd_en(MA_rd_en), 
        .MA_wr_en(MA_wr_en),
        .ddr_rd_done(ddr_rd_done),
        .ddr_data_in(ddr_data_in),
        .ddr_rd_miss(ddr_rd_miss),
        .ddr_wr_miss(ddr_wr_miss),
        .ddr_data_out(ddr_data_out),
        .ddr_addr(ddr_addr),
        .ddr_dirty(ddr_dirty),
        .is_video_data(is_video_data),
        .stall_out(stall_out),
        .mem_rd(mem_rd),
        .MUX_data_out(MUX_data_out),
        .start_done(start_done),
        .start_addr(start_addr)
    );

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
        test_num = 0;
        tests_passed = 0;
        test_case = "Reset Test";
        
        clk = LOW;
        nrst = HIGH;
        flush = LOW;
        stall = LOW;
        
        EX_rd = '0;
        EX_addr = '0;
        EX_data = '0;
        EX_mem_bytes = 2'b11; // 4 bytes by default
        EX_rd_en = LOW;
        EX_wr_en = LOW;
        mem_zero_extend = LOW;
        
        MA_mem_bytes = 2'b11;
        MA_rd_en = LOW;
        MA_wr_en = LOW;
        
        ddr_rd_done = LOW;
        ddr_data_in = '0;
        start_done = LOW;
        start_addr = 32'h0000_0000;

        @(posedge clk);

        $display("\n\ntesting: %s @ %t", test_case, $time);
        reset_dut();

        @(posedge clk);@(posedge clk);

        start_done = HIGH;

        test_case = "Non Load/Store Case";
        $display("\nTesting: %s @ %t", test_case, $time);
        EX_rd_en = LOW; EX_wr_en = LOW;
        EX_addr = 32'h0000_BEEF; // This represents ALU output in a normal instruction
        EX_rd = 5'd5;
        @(posedge clk);
        // Move to MA stage
        MA_rd_en = LOW; MA_wr_en = LOW;
        @(negedge clk);
        if (MUX_data_out !== 32'h0000_BEEF || mem_rd !== 5'd5) begin
            $display("Test failed: ALU result did not bypass memory correctly. MUX_data_out: %0h", MUX_data_out);
        end else begin
            tests_passed++;
        end
        test_num++;

        @(posedge clk);

        test_case = "Flush Test";
        $display("\nTesting: %s @ %t", test_case, $time);
        EX_addr = 32'h12345678;
        EX_rd = 5'd10;
        flush = HIGH;
        @(posedge clk);
        @(negedge clk);
        if (mem_rd !== 0 || MUX_data_out !== 0) begin
            $display("Test failed: Pipeline did not flush correctly. mem_rd: %0d", mem_rd);
        end else begin
            tests_passed++;
        end
        test_num++;
        flush = LOW;

        @(posedge clk);



        test_case = "Normal Store load Sequence";
        $display("\nTesting: %s @ %t", test_case, $time);
        EX_addr = 32'h0000_0100; // Index 4, Tag 0, Offset 0
        EX_data = 32'hAABBCCDD;
        EX_wr_en = HIGH; EX_rd_en = LOW;
        EX_mem_bytes = 2'b11;
        @(posedge clk);
        EX_rd_en = HIGH;
        EX_wr_en = LOW;
        EX_addr = 32'h0000_0100;
        EX_mem_bytes = 2'b11;
        MA_wr_en = HIGH;
        MA_rd_en = LOW;
        MA_mem_bytes = 2'b11;

        @(posedge clk);
        EX_rd_en = LOW;
        MA_rd_en = HIGH; MA_wr_en = LOW;
        MA_mem_bytes = 2'b11;
        @(negedge clk);

        if (MUX_data_out !== 32'hAABBCCDD) begin
            $display("Test failed: Load Hit returned wrong data. Expected: AABBCCDD, Got: %0h", MUX_data_out);
        end else begin
            tests_passed++;
        end

        test_num++;

        @(posedge clk);

        MA_rd_en = LOW;

        @(posedge clk);









    end


endmodule
