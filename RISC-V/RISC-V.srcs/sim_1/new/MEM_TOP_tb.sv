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
        .stall(stall),
        .flush(flush),
        .EX_rd(EX_rd),
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
        
        $display("\nloading BRAM");
        for(int i = 0; i < 8192; i++) begin
            start_addr = i * 4;
            if(i = 8191) begin
                start_done = HIGH;
            end
            @(posedge clk);
        end

        start_done = LOW;

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

        test_case = "Stall Test";
        $display("\nTesting: %s @ %t", test_case, $time);
        
        EX_addr = 32'h0000_1000;
        EX_rd = 5'd8;
        stall = LOW; 
        @(posedge clk); 
        stall = HIGH;
        EX_addr = 32'h0000_2000; 
        EX_rd = 5'd9;
        @(posedge clk);
        @(negedge clk); 
        if (mem_rd !== 5'd8 || MUX_data_out !== 32'h0000_1000) begin
            $display("Test failed: Pipeline did not stall correctly. mem_rd: %0d, MUX_data_out: %0h", mem_rd, MUX_data_out);
        end else begin
            tests_passed++;
        end
        test_num++;
        stall = LOW; 

        @(posedge clk);

//TODO: make sure ts is right gng
        test_case = "Cold Miss Store & Read Hit";
        $display("\nTesting: %s @ %t", test_case, $time);
        
        // 1. Issue Write in EX Stage to a cold address
        EX_addr = 32'h0000_0100; // Index 4, Offset 0
        EX_data = 32'hAABBCCDD;
        EX_wr_en = HIGH; EX_rd_en = LOW;
        EX_mem_bytes = 2'b11; // 4 bytes
        
        @(posedge clk);
        
        // 2. Move Write control signals to MA stage
        // (MEM_TOP automatically propagates EX_addr and EX_data to MA stage registers)
        EX_wr_en = LOW; 
        MA_wr_en = HIGH;
        MA_mem_bytes = 2'b11;

        @(negedge clk); // Check miss logic on negedge
        
        // At this point, valid = 0, so ddr_wr_miss and stall_out should be HIGH
        if (stall_out !== HIGH || ddr_wr_miss !== HIGH) begin
            $display("Test failed: Cold miss did not trigger pipeline stall.");
        end else begin
            $display("Cold miss detected. Simulating DDR block fetch...");
            
            // Wait a few cycles to simulate DDR latency
            #(CLK_PERIOD * 2); 
            
            // The memory controller returns the surrounding 64-byte block (all 0s)
            // Your MA_data_in splicing logic will insert AABBCCDD into this block automatically
            ddr_data_in = '0; 
            ddr_rd_done = HIGH;
            
            @(posedge clk); // Clock in the ddr_rd_done signal
            ddr_rd_done = LOW;
        end
        
        MA_wr_en = LOW; // Clear MA stage write
        @(posedge clk);
        
        // 3. Issue Read to the exact same address
        EX_addr = 32'h0000_0100;
        EX_rd_en = HIGH;
        EX_wr_en = LOW;
        EX_mem_bytes = 2'b11;
        
        @(posedge clk);
        
        // 4. Move Read control signals to MA stage
        EX_rd_en = LOW;
        MA_rd_en = HIGH;
        MA_mem_bytes = 2'b11;
        
        @(negedge clk); // Evaluate the read hit
        
        // Because the block is now valid and the tag matches, it should NOT stall
        if (stall_out === HIGH) begin
            $display("Test failed: Read unexpectedly stalled on what should be a hit.");
        end else if (MUX_data_out !== 32'hAABBCCDD) begin
            $display("Test failed: Load Hit returned wrong data. Expected: AABBCCDD, Got: %0h", MUX_data_out);
        end else begin
            tests_passed++;
        end
        test_num++;

        MA_rd_en = LOW;










        $finish;
    end

endmodule
