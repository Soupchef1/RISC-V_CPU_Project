`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 02:45:43 PM
// Design Name: 
// Module Name: ALU_tb
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

module ALU_tb();
    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;
    
    logic clk;
    
    // ALU Inputs
    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] imm;
    logic [4:0]  MUX_en;
    logic [3:0]  ALU_op;
    
    // ALU Outputs
    logic [31:0] ALU_out;
    logic [31:0] target;
    logic [31:0] pc_next;
    logic        pc_switch;

    // Test bench signals
    int test_num;
    int tests_passed;

    
    task check_alu(
        input logic [31:0] expected_ALU_out,
        input logic [31:0] expected_target,
        input logic [31:0] expected_pc_next,
        input logic        expected_pc_switch,
        output logic       passed
    );
    begin
        #(2);
        
        $display("\nTesting ALU state at time %0t", $time);
        passed = HIGH; 
        
        if(ALU_out != expected_ALU_out) begin
            passed = LOW;
            $display("Test failed: ALU_out mismatch. Expected: %0d (0x%0h), Got: %0d (0x%0h)", expected_ALU_out, expected_ALU_out, ALU_out, ALU_out);
        end
        if(target != expected_target) begin
            passed = LOW;
            $display("Test failed: target mismatch. Expected: %0d, Got: %0d", expected_target, target);
        end
        if(pc_next != expected_pc_next) begin
            passed = LOW;
            $display("Test failed: pc_next mismatch. Expected: %0d, Got: %0d", expected_pc_next, pc_next);
        end
        if(pc_switch != expected_pc_switch) begin
            $display("Test_fail: pc_switch mismatch. Expected: %0b, Got: %0b", expected_pc_switch, pc_switch);
        end
    end
    endtask

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end
   
    ALU Ben_bottom_frag (
        .pc(pc),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .ALU_op(ALU_op),
        .MUX_en(MUX_en),
        .pc_next(pc_next),
        .pc_switch(pc_switch),
        .ALU_out(ALU_out),
        .target(target)
    );

    
    // Input Arrays
    // 1. ADD, 2. ADD+Imm, 3. SUB, 4. XOR, 5. SRA (Shift Right Arith), 6. SLT (Signed Less Than)
    // 7. BEQ (Taken), 8. BNE (Not Taken), 9. JAL, 10. JALR
    logic [31:0] pc_arr[10]       = '{0, 4, 8, 12, 16, 20, 24, 40, 44, 144};
    logic [31:0] rs1_arr[10]      = '{10, 10, 50, 32'hFFFF, 32'hF0000000, 32'hFFFFFFFB, 42, 42, 0, 200}; // rs1_arr[5] is -5
    logic [31:0] rs2_arr[10]      = '{20, 20, 15, 32'h0F0F, 4, 10, 42, 42, 0, 0};
    logic [31:0] imm_arr[10]      = '{0, 100, 0, 0, 0, 0, 16, 16, 100, 8};
    logic [4:0]  mux_en_arr[10]   = '{5'b00000, 5'b00001, 5'b00000, 5'b00000, 5'b00000, 5'b00000, 5'b01000, 5'b01000, 5'b10000, 5'b10100};
    logic [3:0]  alu_op_arr[10]   = '{4'd0, 4'd0, 4'd1, 4'd2, 4'd7, 4'd8, 4'd10, 4'd11, 4'd0, 4'd0};

    // Expected Output Arrays
    logic [31:0] exp_alu_out_arr[10] = '{30, 110, 35, 32'hF0F0, 32'hFF000000, 1, 1, 0, 48, 148};
    logic [31:0] exp_target_arr[10]  = '{0, 104, 8, 12, 16, 20, 40, 56, 144, 208};
    logic [31:0] exp_pc_next_arr[10] = '{4, 8, 12, 16, 20, 24, 40, 44, 144, 208};
    logic        exp_pc_switch_arr[10]= '{0, 0, 0, 0, 0, 0, 1, 0, 1, 1};

    logic alu_passed;

   //the sim
    initial begin
        // Instantiation
        test_num = 0;
        tests_passed = 0;
        clk = 0;
        alu_passed = LOW;

        $display("\n\n--- Starting ALU Verification ---");

        for(int i = 0; i < 10; i++) begin
            @(posedge clk);
            
            pc       = pc_arr[i];
            rs1_data = rs1_arr[i];
            rs2_data = rs2_arr[i];
            imm      = imm_arr[i];
            MUX_en   = mux_en_arr[i];
            ALU_op   = alu_op_arr[i];

            check_alu(exp_alu_out_arr[i], exp_target_arr[i], exp_pc_next_arr[i], exp_pc_switch_arr[i], alu_passed);
            
            tests_passed += alu_passed;
            test_num++;
        end

        $display("\n\n---------------------------------");
        $display("Test Summary: %0d/%0d tests passed", tests_passed, test_num);
        $display("---------------------------------\n");

        @(posedge clk);
        $finish;
    end
endmodule