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

// -------------------------
    // Signal Declarations
    // -------------------------
    logic clk;
    logic nrst;

    // EX Stage Inputs
    logic [4:0]  EX_rd;
    logic [31:0] EX_addr;
    logic [31:0] EX_data;
    logic [1:0]  EX_mem_bytes;
    logic [1:0]  MA_mem_bytes;
    logic        mem_zero_extend;
    
    // Pipeline Control Signals
    logic flush, stall, FU_stall;
    logic EX_rd_en, EX_wr_en, MA_rd_en, MA_wr_en;
    
    // DDR Memory Controller Interface
    logic        ddr_rd_done;
    logic [511:0] ddr_data_in;
    
    // Startup Sequence
    logic [31:0] start_addr;
    logic        start_done;

    // Outputs
    logic         stall_out;
    logic         ddr_rd_miss;
    logic         ddr_wr_miss;
    logic [511:0] ddr_data_out;
    logic [31:0]  ddr_addr;
    logic         ddr_dirty;
    logic         is_video_data;
    logic [31:0]  MUX_data_out;
    logic [4:0]   mem_rd;
    logic         buffer_change;

    // -------------------------
    // Device Under Test (DUT)
    // -------------------------
    MEM_TOP dut (
        .clk(clk),
        .nrst(nrst),
        .EX_rd(EX_rd),
        .EX_addr(EX_addr),
        .EX_data(EX_data),
        .EX_mem_bytes(EX_mem_bytes),
        .MA_mem_bytes(MA_mem_bytes),
        .mem_zero_extend(mem_zero_extend),
        .flush(flush),
        .stall(stall),
        .FU_stall(FU_stall),
        .EX_rd_en(EX_rd_en),
        .EX_wr_en(EX_wr_en),
        .MA_rd_en(MA_rd_en),
        .MA_wr_en(MA_wr_en),
        .stall_out(stall_out),
        .ddr_rd_done(ddr_rd_done),
        .ddr_data_in(ddr_data_in),
        .ddr_rd_miss(ddr_rd_miss),
        .ddr_wr_miss(ddr_wr_miss),
        .ddr_data_out(ddr_data_out),
        .ddr_addr(ddr_addr),
        .ddr_dirty(ddr_dirty),
        .is_video_data(is_video_data),
        .MUX_data_out(MUX_data_out),
        .mem_rd(mem_rd),
        .start_addr(start_addr),
        .start_done(start_done),
        .buffer_change(buffer_change)
    );

    // -------------------------
    // Hazard Unit Mock
    // -------------------------
    // Automatically freeze the pipeline registers when the cache misses.
    assign stall = stall_out;

    // -------------------------
    // Clock Generation
    // -------------------------
    always #5 clk = ~clk;

    // -------------------------
    // Test Sequence
    // -------------------------
    initial begin
        // Initialize all signals
        clk = 0;
        nrst = 0;
        EX_rd = 0; EX_addr = 0; EX_data = 0; 
        EX_mem_bytes = 0; MA_mem_bytes = 0; mem_zero_extend = 0;
        flush = 0; FU_stall = 0;
        EX_rd_en = 0; EX_wr_en = 0; MA_rd_en = 0; MA_wr_en = 0;
        ddr_rd_done = 0; ddr_data_in = '0;
        start_addr = 0; start_done = 0;

        // 1. Reset and Startup Sequence
        #20;
        nrst = 1;
        
        @(posedge clk);
        start_done = 1; // Break Data_cache out of STARTUP state
        
        @(posedge clk);
        start_done = 0;

        // =================================================================
        // Pipeline Execution: i1 (Write) and i2 (Read) overlapping
        // =================================================================
        $display("\n[%0t] Starting i1 (EX Stage): Write to 0x0000_1000", $time);
        
        EX_wr_en = 1;
        EX_addr = 32'h0000_1000;
        EX_data = 32'hDEADBEEF;
        EX_mem_bytes = 2'b11;
        
        @(posedge clk);
        
        $display("[%0t] i1 moves to MA Stage (Miss). i2 enters EX Stage.", $time);
        
        // Push i1 control signals to MA
        EX_wr_en = 0;
        MA_wr_en = 1;
        MA_mem_bytes = 2'b11; 
        
        // Assert i2 into EX simultaneously
        EX_rd_en = 1;
        EX_addr  = 32'h0000_1000;
        EX_mem_bytes = 2'b11;

        @(posedge clk);
        
        if (stall_out) begin
            $display("[%0t] Pipeline stalled! i1 is frozen in MA, i2 is waiting in EX.", $time);
            
            #20;
            @(posedge clk);
            
            ddr_rd_done = 1;
            ddr_data_in = {16{32'hCAFEBABE}}; // Dummy backing data
            
            @(posedge clk);
            ddr_rd_done = 0;
            
            wait(!stall_out);
            $display("[%0t] Stall lifted. i1 completing, i2 advancing to MA.", $time);
        end
        
        @(posedge clk);
        
        MA_wr_en = 0;      
        MA_rd_en = 1;      
        EX_rd_en = 0;      
        
        @(posedge clk);
        $display("[%0t] i2 Read Hit Output (MUX_data_out): %h", $time, MUX_data_out);
        MA_rd_en = 0;
        
        // =================================================================
        // i3: Cache Bypass (MMIO Write)
        // =================================================================
        $display("\n[%0t] Starting i3: MMIO Bypass Write", $time);
        
        EX_wr_en = 1;
        EX_addr = 32'h1000_0000; 
        EX_data = 32'h12345678;
        EX_mem_bytes = 2'b11;
        @(posedge clk);
        
        $display("[%0t] MMIO buffer_change flag asserted: %b", $time, buffer_change);
        
        EX_wr_en = 0;
        MA_wr_en = 1;
        MA_mem_bytes = 2'b11;
        
        @(posedge clk);
        $display("[%0t] DDR Write Miss Flag (Expected 0): %b", $time, ddr_wr_miss);
        MA_wr_en = 0;

        // =================================================================
        // i4: Read Miss at new address 0x0000_2000
        // =================================================================
        $display("\n[%0t] Starting i4: Read Miss at 0x0000_2000", $time);
        
        // Cycle 1: EX Stage
        EX_rd_en = 1;
        EX_addr = 32'h0000_2000;
        EX_mem_bytes = 2'b11;
        @(posedge clk);
        
        // Cycle 2: Propagate to MA
        EX_rd_en = 0;
        MA_rd_en = 1;
        MA_mem_bytes = 2'b11;
        
        @(posedge clk);
        
        if (stall_out) begin
            $display("[%0t] Pipeline stalled for i4 Read Miss. Fetching DDR...", $time);
            
            #20;
            @(posedge clk);
            
            ddr_rd_done = 1;
            ddr_data_in = {16{32'hBEEFCAFE}}; // Distinct data for read miss return
            
            @(posedge clk);
            ddr_rd_done = 0;
            
            wait(!stall_out);
            $display("[%0t] i4 Stall lifted.", $time);
        end
        
        @(posedge clk);
        $display("[%0t] i4 Read Miss Output (MUX_data_out): %h (Expected BEEFCAFE)", $time, MUX_data_out);
        MA_rd_en = 0;

        // =================================================================
        // i5: Pipeline Flush Test
        // =================================================================
        $display("\n[%0t] Starting i5: Pipeline Flush Test", $time);
        
        // Cycle 1: Put instruction in EX stage
        EX_wr_en = 1;
        EX_addr = 32'h0000_4000;
        EX_data = 32'h11223344;
        EX_mem_bytes = 2'b11;
        @(posedge clk);
        
        // Cycle 2: Hazard unit detects branch mispredict, asserts flush.
        $display("[%0t] Asserting flush signal...", $time);
        flush = 1;
        EX_wr_en = 0; 
        
        // Simulating hazard unit trying to advance controls but flush intercepts register update
        MA_wr_en = 1; 
        MA_mem_bytes = 2'b11;
        
        @(posedge clk);
        flush = 0;
        
        // Verify internal MEM_TOP registers reset to zero
        $display("[%0t] Flush applied. MA_addr inside DUT is: %h (Expected 00000000)", $time, dut.MA_addr);
        $display("[%0t] MA_data_in inside DUT is: %h (Expected 00000000)", $time, dut.MA_data_in);
        MA_wr_en = 0;

        // End simulation safely
        #50;
        $display("\nSimulation complete.");
        $finish;
    end

endmodule