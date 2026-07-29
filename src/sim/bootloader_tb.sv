`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2026 08:22:46 PM
// Design Name: 
// Module Name: bootloader_tb
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


module bootloader_tb(

    );

    localparam CLK_PERIOD = 10;
    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;
    localparam int BIT_PERIOD = 500;


    logic clk, nrst;

    logic uart_rx, mig_ready;
    logic start_done, start_valid, start_write_en;
    logic [31:0] start_addr, start_data;

    logic axi_ctrl_bvalid, boot_start, pkt_failed;

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end

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

    bootloader DUT(.*);

    logic [31:0] data_arr[10] = '{
        32'h4A8F2C1E,
        32'h9B3D7E05,
        32'h1F4A6C89,
        32'hE25B9A34,
        32'h7C2F1D8B,
        32'h38E409AF,
        32'hF16D2C7E,
        32'h5A9E3B12,
        32'h8D4F6A0C,
        32'h2E1B7F96
    };

    logic [31:0] addr_arr[10] = '{
        32'd320,
        32'd324,
        32'd328,
        32'd332,
        32'd336,
        32'd340,
        32'd344,
        32'd348,
        32'd352,
        32'd356
    };

    task run_byte(
        input logic [7:0] byte_data
    );  
        uart_rx = LOW;
        #(BIT_PERIOD);
        for(int i = 0; i < 8; i++) begin
            uart_rx = byte_data[i];
            #(BIT_PERIOD);
        end
        uart_rx = HIGH;
        #(BIT_PERIOD);
    endtask


    task run_packet(
        input logic [31:0] data,
        input logic [31:0] addr
    );
        logic [31:0] checksum = addr[23:16] ^ addr[15:8] ^ addr[7:0] ^ data[31:24] ^ data[23:16] ^ data[15:8] ^ data[7:0];

        #($urandom_range(BIT_PERIOD));
        run_byte(.byte_data(8'hAB));
        run_byte(.byte_data(addr[25:18]));
        run_byte(.byte_data(addr[17:10]));
        run_byte(.byte_data(addr[9:2]));

        run_byte(.byte_data(data[31:24]));
        run_byte(.byte_data(data[23:16]));
        run_byte(.byte_data(data[15:8]));
        run_byte(.byte_data(data[7:0]));
        run_byte(.byte_data(checksum));
    endtask

    task check_packet(
        input logic [31:0] data_expected,
        input logic [31:0] addr_expected,
        output logic passed
    );
        passed = LOW;
        @(posedge start_write_en);

        if(start_addr != addr_expected) begin
            $display("Test failed: wrong addr, expected %h, got %h", addr_expected, start_addr);
        end
        if(start_data != data_expected) begin
            $display("Test failed: wrong data, expected %h, got %h", data_expected, start_data);
        end
        if(start_addr == addr_expected && start_data == data_expected) begin
            passed = HIGH;
        end

    endtask


    string test_case;
    int test_num;
    int tests_passed;

    logic passed;

    initial begin
        clk = LOW;
        nrst = HIGH;
        uart_rx = HIGH;
        mig_ready = LOW;

        axi_ctrl_bvalid = HIGH;

        test_case = "Reset";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        test_num = 0;
        tests_passed = 0;

        passed = LOW;
        
        reset_dut();

        @(posedge clk); @(posedge clk);

        mig_ready = HIGH;

        @(posedge boot_start); @(posedge clk);

        test_case = "Bit stream";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        
        for(int i = 0; i < 10; i++)begin
            $display("testing packet %d @ %t", i, $time);
            fork
                begin
                    run_packet(
                        .data(data_arr[i]),
                        .addr(addr_arr[i])
                    );
                end

                begin
                    test_num++;

                    check_packet(
                        .data_expected(data_arr[i]),
                        .addr_expected(addr_arr[i]),
                        .passed(passed)                        
                    );

                    if(passed == HIGH) begin
                        tests_passed++;
                    end
                end
            join
        end

        $display("Test: %s finished @ %t. %d/%d passed", test_case, $time, tests_passed, test_num);

        @(posedge clk);
        @(posedge clk);
        $finish;
    end
    

endmodule
