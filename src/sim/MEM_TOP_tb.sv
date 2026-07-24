`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GOON LLC
// Engineer: Benjamin Li and Ryan Karami
// 
// Design Name: memory top tb
// Module Name: MEM_TOP_tb
// Project Name: GOON-PU
// Target Devices: ARTY s7-25
// Description: Startup sequence followed by I1 (write miss), I2 (read), I3 (normal op).
//////////////////////////////////////////////////////////////////////////////////

module MEM_TOP_tb();

    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    logic clk, nrst, flush;
    
    // Wire the stall signal to automatically respect cache misses
    logic force_stall;
    logic stall;
    assign stall = force_stall | stall_out;

    logic [4:0] EX_rd;
    logic [31:0] EX_addr;
    logic [31:0] EX_data;
    logic [1:0] EX_mem_bytes, MA_mem_bytes; 
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
        nrst = 1'b0;
        @(posedge clk);
        @(posedge clk);
        nrst = 1'b1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    string test_case;
    int test_num;
    int tests_passed;

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end

    initial begin
        test_num = 0;
        tests_passed = 0;
        test_case = "Reset & Startup Sequence";
        
        clk = LOW;
        nrst = HIGH;
        flush = LOW;
        force_stall = LOW;
        
        EX_rd = '0;
        EX_addr = '0;
        EX_data = '0;
        EX_mem_bytes = 2'b11; 
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

        $display("\n\nTesting: %s @ %t", test_case, $time);
        reset_dut();
        force_stall = HIGH;

        $display("\nLoading BRAM...");
        for(int i = 0; i < 8192; i++) begin
            start_addr = i * 4;
            if(i == 8191) begin
                start_done = HIGH;
            end
            @(posedge clk);
        end

        @(posedge clk);
        @(posedge clk);
        
        force_stall = LOW;
        start_done = LOW;

        test_case = "I1 (Write Miss) -> I2 (Read) -> I3 (Normal Op)";
        $display("\nTesting: %s @ %t", test_case, $time);
        
        // Cycle 1: Issue I1 (Write) in EX Stage to a cold address
        EX_addr = 32'h0000_0200; 
        EX_data = 32'hDEADBEEF;
        EX_wr_en = HIGH; 
        EX_rd_en = LOW;
        EX_mem_bytes = 2'b11; 
        
        @(posedge clk);
        
        // Cycle 2: I1 moves to MA, put I2 (Read) in EX to same address
        EX_wr_en = LOW; 
        MA_wr_en = HIGH;
        MA_mem_bytes = 2'b11;
        
        EX_addr = 32'h0000_0200;
        EX_rd_en = HIGH;
        EX_mem_bytes = 2'b11;
        
        @(negedge clk); 
        
        if (stall_out !== HIGH) begin
            $display("Test failed: Back-to-back write miss did not stall pipeline.");
        end else begin
            $display("Pipeline stalled by I1. Simulating DDR fetch...");
            
            #(CLK_PERIOD * 3); 
            
            ddr_data_in = '0; 
            ddr_rd_done = HIGH;
            
            @(posedge clk); 
            ddr_rd_done = LOW;
            
        end
        
        // Cycle 3: I1 clears MA, I2 enters MA, I3 (Normal Op) enters EX.
        MA_wr_en = LOW; 
        MA_rd_en = HIGH;
        MA_mem_bytes = 2'b11;
        
        EX_rd_en = LOW;
        EX_wr_en = LOW;
        EX_addr = 32'h0000_BEEF; // Standard ALU output bypassing memory
        EX_rd = 5'd5;            // Target register
        
        @(negedge clk); 
        
        // Verify I2 Read Data
        if (stall_out === HIGH) begin
            $display("Test failed: I2 Read unexpectedly stalled.");
        end else if (MUX_data_out !== 32'hDEADBEEF) begin
            $display("Test failed: I2 Read returned wrong data. Expected: DEADBEEF, Got: %0h", MUX_data_out);
        end else begin
            $display("I2 read hazard resolved successfully!");
            tests_passed++;
        end

        @(posedge clk);

        // Cycle 4: I2 clears MA, I3 moves to MA
        MA_rd_en = LOW; 
        
        @(negedge clk);

        // Verify I3 bypassed memory correctly
        if (MUX_data_out !== 32'h0000_BEEF || mem_rd !== 5'd5) begin
            $display("Test failed: I3 ALU result did not bypass memory correctly. MUX_data_out: %0h", MUX_data_out);
        end else begin
            $display("I3 normal op bypassed memory successfully!");
            tests_passed++;
        end

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


//read miss test
        test_case = "read Miss";
        $display("\nTesting: %s @ %t", test_case, $time);
        
        // 1. Issue read in EX Stage to a prevous cache line address w/ diff tag
        EX_addr = 32'h0000_8100; // Index 4, Offset 0
        EX_wr_en = LOW; EX_rd_en = HIGH;
        EX_mem_bytes = 2'b11; // 4 bytes
        
        @(posedge clk);
        
        // 2. Move Write control signals to MA stage
        // (MEM_TOP automatically propagates EX_addr and EX_data to MA stage registers)
        EX_rd_en = LOW; 
        MA_rd_en = HIGH;
        MA_mem_bytes = 2'b11;

        @(negedge clk); // Check miss logic on negedge
        
        // At this point, valid = 0, so ddr_wr_miss and stall_out should be HIGH
        if (stall_out !== HIGH || ddr_rd_miss !== HIGH) begin
            $display("Test failed: miss did not trigger pipeline stall.");
        end else begin
            $display(" miss detected. Simulating DDR block fetch...");
            
            // Wait a few cycles to simulate DDR latency
            #(CLK_PERIOD * 2); 
            
            // The memory controller returns the surrounding 64-byte block (all 0s)
            // Your MA_data_in splicing logic will insert AABBCCDD into this block automatically
            ddr_data_in = {16{32'h0000_ABCD}}; 
            ddr_rd_done = HIGH;
            
            @(posedge clk); // Clock in the ddr_rd_done signal
            ddr_rd_done = LOW;
                        
            if (ddr_dirty !== HIGH) begin
                $display("Test failed: Dirty bit was not asserted for the evicted block.");
            end

            if (MUX_data_out !== 32'h0000_ABCD) begin
                $display("Test failed: Read miss returned wrong data. Expected: 0000_ABCD, Got: %0h", MUX_data_out);
            end else begin
                tests_passed++;
            end
        end
        
        test_num++;

        @(posedge clk);


        $display("\nSimulation Finished. Tests Passed: %0d", tests_passed);
        $finish;
    end

endmodule