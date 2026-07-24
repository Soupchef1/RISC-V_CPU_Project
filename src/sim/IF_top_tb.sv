`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 09:11:59 PM
// Design Name: 
// Module Name: IF_top_tb
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


module IF_top_tb(
    );

    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    logic clk, nrst, flush, stall;
    logic [31:0] PC_next, instr, PC_out, PC_Ex, target, start_data, start_addr, ID_addr, ddr_addr;
    logic [4:0] MUX_en;
    logic predicted_jump, pc_switch, start_done, ddr_rd_done, ddr_rd_miss, stall_out;
    logic [511:0] ddr_data_in;

    IF_top DUT(.*);

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

    // input logic clk, nrst, flush, stall,
    // input logic [31:0] PC_next,
    // output logic [31:0] instr,
    // output logic [31:0] PC_out, //to decode pipeline reg

    // //branch mem signals
    // input logic predicted_jump, //from ex stage
    // input logic [4:0] MUX_en, //from decode stage
    // input logic pc_switch, //from ex stage
    // input logic [31:0] PC_Ex, //from ex stage
    // input logic [31:0] target, //from ex_stage

    // //instruction cache signals
    // input logic [31:0] ID_addr, //PC from decode stage
    // input logic [31:0] start_data,
    // input logic [31:0] start_addr,
    // input logic start_done,
    // input logic ddr_rd_done,
    // input logic [511:0] ddr_data_in,
    // output logic ddr_rd_miss,
    // output logic [31:0] ddr_addr,
    // output logic stall_out

    int count;
    int temp_out;

    assign stall = stall_out;

    initial begin
        test_num = 0;
        tests_passed = 0;
        test_case = "Reset Test";
        clk = LOW;
        nrst = HIGH;
        flush = HIGH;
        stall = LOW;
        PC_next = 32'h0000_0000;
        predicted_jump = LOW;
        MUX_en = '0;
        pc_switch = LOW;
        PC_Ex = '0;
        target = '0;
        ID_addr = '0;
        start_data = '0;
        start_addr = '0;
        start_done = LOW;
        ddr_rd_done = LOW;
        ddr_data_in = '0;

        @(posedge clk);

        $display("\n\ntesting: %s @ %t", test_case, $time);
        reset_dut();

        @(posedge clk);@(posedge clk);

        //regular use case testing
        test_case = "incrementing PC";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        flush = LOW;
        count = 0;
        for(int i = 0; i < 10; i++) begin
            if(PC_out == i * 4) begin
                count++;
            end

            @(posedge clk);
        end

        if(count != 10) begin
            $display("Test failed: PC did not increment correctly. Expected: 10, Got: %0d", count);
        end else begin
            tests_passed++;
        end

        test_num++;

        test_case = "stall test";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        stall = HIGH;
        temp_out = PC_out;

        @(posedge clk);@(posedge clk);
        if(PC_out != temp_out) begin
            $display("Test failed: PC did not stall correctly. Expected: %0d, Got: %0d", temp_out, PC_out);
        end else begin
            tests_passed++;
        end

        test_num++;

        test_case = "flush test";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        stall = LOW;
        flush = HIGH;
        PC_next = 32'h0000_1000;

        @(posedge clk);
        if(PC_out != PC_next) begin
            $display("Test failed: PC did not flush correctly. Expected: %0d, Got: %0d", PC_next, PC_out);
        end else begin
            tests_passed++;
        end
        test_num++;

        PC_next = 32'h0000_0000;
        @(posedge clk);
        flush = LOW;

        //BRAM loading
        $display("\nloading BRAM");
        for(int i = 0; i < 8192; i++) begin
            start_addr = i * 4;
            start_data = i;
            @(posedge clk);
        end

        start_done = HIGH;

        @(posedge clk);

        start_done = LOW;
        test_case = "BRAM read test";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        @(posedge clk);
        flush = HIGH;

        //bulk testing
        for(int i = 0; i < 10; i++) begin
            @(negedge clk);
            PC_next = $urandom_range(0, 8192) * 4;
            temp_out = PC_next;
            @(posedge clk);
            @(posedge clk);
            ID_addr = PC_out;

            @(negedge clk);
            if(instr != temp_out / 4) begin
                $display("Test failed: BRAM read error @ %t. Read PC: %0d, Expected: %0d, Got: %0d", $time, temp_out, temp_out / 4, instr);
            end else begin
                tests_passed++;
            end
            test_num++;
        end
        @(posedge clk);

        //cache miss testing
        test_case = "cache miss test";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        @(posedge clk);
        flush = HIGH;
        @(negedge clk);
        PC_next = 32'h0000_8000;
        @(posedge clk);
        @(posedge clk);
        flush = LOW;
        ID_addr = PC_out;
        @(posedge clk);
        @(posedge clk);

        //simulate DDR read done
        ddr_rd_done = HIGH;
        for(int i = 0; i < 16; i++) begin
            ddr_data_in[i * 32 +: 32] = {28'h7000000, 4'(i)};
        end
        @(posedge clk);
        @(posedge clk);
        ID_addr = PC_out;
        @(posedge clk);
        ID_addr = PC_out;
        @(posedge clk);
        ID_addr = PC_out;


        //test summary
        $display("\n\nTest Summary: %0d/%0d tests passed", tests_passed, test_num);

        @(posedge clk);
        $finish;                
    end
endmodule
