`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2026 06:45:00 PM
// Design Name: 
// Module Name: signal_generator_tb
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


module signal_generator_tb(
// signal declaration
    // testbench parameters
    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LWO = 1'b0;

    // testbench trackers
    string test_case;
    int test_num;
    int tests_passed;
    logic passed;

    // global signals
    logic clk;
    logic nrst;

    // signal gen inputs 
    input logic [4:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,

    // signal gen outputs
    output logic [4:0] MUX_en,
    output logic [3:0] ALU_op,
    output logic mem_write, mem_read, write_back,
    output logic [1:0] mem_bytes, //00: no bytes, 01: 1 byte, 10: 2 bytes, 11: 4 bytes
    output logic mem_zero_extend
    );

// reset function
    task reset_dut; begin
        nrst = LOW;
        @(posedge clk); //wait
        @(posedge clk);
        nrst = HIGH;
        @(posedge clk); //wait
        @(posedge clk);
    end
    endtask

// test instruction function
    task check_signal_gen(
        input logic [4:0] opcode_tb,
        input logic [2:0] func3_tb,
        input logic [6:0] func7_tb,
        input logic [4:0] expected_MUX_en,
        input logic [3:0] expected_ALU_op,
        input logic expected_mem_write, expected_mem_read, expected_write_back,
        input logic [1:0] expected_mem_bytes, 
        input logic expected_mem_zero_extend,
        output logic passed
    ); begin
        // input instruction
        opcode = opcode_tb;
        func3 = func3_tb;
        func3 = func7_tb;
        #(2);
        $display("\nTesting opcode %b, func3 %b, func7 %b at time %t", opcode, func3, func7, $time);

        // checking each output
        passed = HIGH;
        if(MUX_en != expected_MUX_en) begin
            $display("Test failed: MUX_en mismatch. Expected %0b, got %0b", expected_MUX_en, MUX_en);
            passed = LOW;
        end
        if(ALU_op != expected_ALU_op)begin
            $display("Test failed: ALU_op mismatch. Expected %0b, got %0b", expected_ALU_op, ALU_op);
            passed = LOW;
        end
        if(mem_write != expected_mem_write)begin
            $display("Test failed: mem_write mismatch. Expected %0b, got %0b", expected_mem_write, mem_write);
            passed = LOW;
        end
        if(mem_read != expected_mem_read)begin
            $display("Test failed: mem_read mismatch. Expected %0b, got %0b", expected_mem_read, mem_read);
            passed = LOW;
        end
        if(write_back != expected_write_back)begin
            $display("Test failed: write_back mismatch. Expected %0b, got %0b", expected_write_back, write_back);
            passed = LOW;
        end
        if(mem_bytes != expected_mem_bytes)begin
            $display("Test failed: mem_bytes mismatch. Expected %0b, got %0b", expected_mem_bytes, mem_bytes);
            passed = LOW;
        end
        if(mem_zero_extend != expected_mem_zero_extend)begin
            $display("Test failed: mem_zero_extend mismatch. Expected %0b, got %0b", expected_mem_zero_extend, mem_zero_extend);
            passed = LOW;
        end
    end
    endtask

// clock loop
    always begin
        #CLK_PERIOD/2.0;
        clk = ~clk;
    end

// defining test cases and expected values
    logic [4:0] opcode_tb_arr = '{};
    logic [2:0] func3_tb_arr =  '{};
    logic [6:0] func7_tb_arr =  '{};
    logic [4:0] expected_MUX_en_arr = '{};
    logic [3:0] expected_ALU_op_arr = '{};
    logic expected_mem_write_arr = '{};
    logic expected_mem_read_arr = '{};
    logic expected_write_back_arr = '{};
    logic [1:0] expected_mem_bytes_arr = '{};
    logic expected_mem_zero_extend_arr = '{};
// 

    //running test cases
    //inputs: clk, nrst, opcode, func3, func7
    // outputs: MUX_en, ALU_op, mem_write, mem_read, write_back, mem_bytes, mem_zero_extend
    initial begin
    // initializing test signals
        test_num = 0;
        tests_passed = 0;
        passed = LOW;
        clk = LOW;
        nrst = HIGH;

        // testing reset
        test_case = "reset"
        $display("\nTesting %s", test_case);
        reset_dut();

        // going through test cases
        @(posedge clk);
        test_case = "signal generation";
        $display("\nTesting %s", test_case);

        // Initialize outputs
        MUX_en = '0;
        ALU_op = '0;
        mem_write = LOW;
        mem_read = LOW;
        write_back = LOW;
        mem_bytes = '0;
        mem_zero_extend = LOW;

        for(int i = 0; i < $size(opcode_tb_arr), i++) begin
            @(posedge clk);
            check_signal_gen(opcode_tb_arr[i], func3_tb_arr[i], func7_tb_arr[i],
            expected_MUX_en_arr[i], expected_ALU_op_arr[i], expected_mem_write[i], 
            expected_mem_read_arr[i], expected_write_back_arr[i], expected_mem_bytes_arr[i], 
            expected_mem_zero_extend_arr[i], passed);
            tests_passed += passed;
            test_num++;
        end

        // print results
        $display("\n\nTest Summary: %0d/%0d tests passed", tests_passed, test_num);
        $finish;
    end



endmodule
