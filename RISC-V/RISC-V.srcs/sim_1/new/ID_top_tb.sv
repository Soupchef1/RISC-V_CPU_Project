`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2026 04:55:29 PM
// Design Name: 
// Module Name: ID_top_tb
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


module ID_top_tb();
    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;
    
    // DUT signals
    // global signals
    logic clk, nrst;
    
    //decode signals 
    logic [31:0] PC_in;
    logic [31:0] instr_in;
    logic [31:0] PC_out;
    logic [31:0] rs1_data, rs2_data, imm;
    logic [4:0] rd;

    //write back signals
    logic wb_en;
    logic [4:0] wb_addr;
    logic [31:0] wb_data;

    //controller signals
    logic flush_en, stall_en;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [4:0] rs1_addr, rs2_addr;
    logic [4:0] opcode;

    // test bench signals
    string test_case;
    int test_num;
    int tests_passed;

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

    task check_decode(
        input logic [31:0] instruction,
        input logic [4:0] expected_rd,
        input logic [2:0] expected_func3,
        input logic [4:0] expected_rs1, expected_rs2,
        input logic [6:0] expected_func7,
        input logic [31:0] expected_imm,
        output logic passed
    );
    begin
        instr_in = instruction;
        #(2);
        $display("\ntesting instruction %b at time %t", instruction, $time);
        passed = HIGH; 
        if(rd != expected_rd) begin
            passed = LOW;
            $display("Test failed: rd mismatch. Expected: %0b, Got: %0b", expected_rd, rd);
        end
        if(func3 != expected_func3) begin
            passed = LOW;
            $display("Test failed: func3 mismatch. Expected: %0b, Got: %0b", expected_func3, func3);
        end
        if(rs1_addr != expected_rs1) begin
            passed = LOW;
            $display("Test failed: rs1 mismatch. Expected: %0b, Got: %0b", expected_rs1, rs1_addr);
        end
        if(rs2_addr != expected_rs2) begin
            passed = LOW;
            $display("Test failed: rs2 mismatch. Expected: %0b, Got: %0b", expected_rs2, rs2_addr);
        end
        if(func7 != expected_func7) begin
            $display("func7 mismatch. Expected: %0b, Got: %0b", expected_func7, func7);
        end
        if(imm != expected_imm) begin
            $display("Gemini messed up: imm mismatch. Expected: %0b, Got: %0b", expected_imm, imm);
        end
    end
    endtask

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end

    ID_top  DUT(.*);

    logic [31:0] instr_arr[20] = '{
        32'b11111011010100110110101000010011,
        32'b11100100111001110001011111101111,
        32'b01110110000011100111000011100011,
        32'b10110010000000000011011010110111,
        32'b00101101111010001001110000110111,
        32'b00111100100111101111001101100011,
        32'b00000001110110111110101110110011,
        32'b11111011011011111110110010010011,
        32'b00001100111111100001100000010111,
        32'b11011010011000011010111010100011,
        32'b11110001000101111100010011101111,
        32'b00000010101000111011111101101111,
        32'b01110000011000101101110011101111,
        32'b01010100100100010111100111100011,
        32'b00111001000011110001101111101111,
        32'b00000111111000101001111111101111,
        32'b10000100100001011000111010110111,
        32'b11010110100101000001010111101111,
        32'b00100100011010111001100111100011,
        32'b11100111000000000000111000000011
    };

    logic [4:0]  rd_arr[20]     = '{5'd20, 5'd15, 5'd0,  5'd13, 5'd24, 5'd0,  5'd23, 5'd25, 5'd16, 5'd0,  5'd9,  5'd30, 5'd25, 5'd0,  5'd23, 5'd31, 5'd29, 5'd11, 5'd0,  5'd28};
    logic [2:0]  func3_arr[20]  = '{3'b110, 3'b000, 3'b111, 3'b000, 3'b000, 3'b111, 3'b110, 3'b110, 3'b000, 3'b010, 3'b000, 3'b000, 3'b000, 3'b111, 3'b000, 3'b000, 3'b000, 3'b000, 3'b001, 3'b000};
    logic [4:0]  rs1_arr[20]    = '{5'd6,  5'd0,  5'd28, 5'd0,  5'd0,  5'd29, 5'd23, 5'd31, 5'd0,  5'd3,  5'd0,  5'd0,  5'd0,  5'd2,  5'd0,  5'd0,  5'd0,  5'd0,  5'd23, 5'd0};
    logic [4:0]  rs2_arr[20]    = '{5'd0,  5'd0,  5'd0,  5'd0,  5'd0,  5'd9,  5'd29, 5'd0,  5'd0,  5'd6,  5'd0,  5'd0,  5'd0,  5'd9,  5'd0,  5'd0,  5'd0,  5'd0,  5'd6,  5'd0};
    logic [6:0]  func7_arr[20]  = '{7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0,  7'b0};

    logic [31:0] imm_arr[20] = '{
        32'hFFFFFFB5, // 1. -75
        32'hE4E717EF, // 2. -584114
        32'h00000F60, // 3. 3936
        32'hB2003000, // 4. -1308610560
        32'h2DE89000, // 5. 770215936
        32'h000003C6, // 6. 966
        32'h00000000, // 7. N/A (0)
        32'hFFFFFFB6, // 8. -74
        32'h0CFE1000, // 9. 217976832
        32'hFFFFFDC3, // 10. -579
        32'hFFF7CF10, // 11. -536816
        32'h0003B02A, // 12. 241706
        32'h0002D706, // 13. 186118
        32'h00000D52, // 14. 3410
        32'h000F1390, // 15. 988048
        32'h0002907E, // 16. 168062
        32'h84858000, // 17. -2071625728
        32'hFFF41D68, // 18. -778904
        32'h00000A52, // 19. 2642
        32'hFFFFFE70  // 20. -400
    };

    //inputs: clk, nrst, PC_in, instr_in, wb_en, wb_addr, wb_data, flush_en, stall_en
    //outputs: PC_out, rs1_data, rs2_data, imm, rd, func3, func7, rs1_addr, rs2_addr, opcode
    logic decode_passed;
    initial begin
        // value instatiation
        test_num = 0;
        tests_passed = 0;
        clk = 0;
        nrst = 1;
        decode_passed = LOW;

        //test reset
        test_case = "reset";
        $display("\n\ntesting: %s", test_case);
        reset_dut();

        @(posedge clk);
        //test instruction decode
        test_case = "instruction decode";
        $display("\n\ntesting: %s", test_case);

        PC_in = '0;
        wb_en = LOW;
        wb_addr = '0;
        wb_data = '0;
        flush_en = LOW;
        stall_en = LOW;

        for(int i = 0; i < 20; i++) begin
            @(posedge clk);
            check_decode(instr_arr[i], rd_arr[i], func3_arr[i], rs1_arr[i], rs2_arr[i], func7_arr[i], imm_arr[i], decode_passed);
            tests_passed += decode_passed;
            test_num++;
        end

        $display("\n\nTest Summary: %0d/%0d tests passed", tests_passed, test_num);

        @(posedge clk);
        $finish;
    end
endmodule
