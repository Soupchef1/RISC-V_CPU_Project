`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 05:10:00 PM
// Design Name: 
// Module Name: CPU_top_tb
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


module CPU_top_tb(

    );

    localparam int CLKPERIOD = 10;
    localparam logic LOW = 1'b0;
    localparam logic HIGH = 1'b1;

    logic clk, nrst, ins_read_done, data_read_done, data_write_done, start_valid, start_write_en, start_done;
    logic ins_rd_miss, data_rd_miss, data_wr_miss, data_dirty, video_data, buffer_change;

    logic [31:0] ins_addr, data_addr, data_addr_dirty, start_addr, start_data;
    logic [511:0] ins_data_out, data_data_in, data_data_out;

    CPU_top DUT(.*);

    logic [511:0] memory[logic[31:0]];

    always begin
        clk = ~clk;
        #(CLKPERIOD);
    end

    task load_data (
        input [31:0] data,
        input [31:0] addr
    ); 
        repeat(2) @(posedge clk);
        start_valid = HIGH;
        start_write_en = HIGH;
        start_addr = addr;
        start_data = data;
        @(posedge clk);
        start_valid = LOW;
        start_write_en = LOW;
    endtask

    logic [32:0] test_program[] = '{
        32'b0
    };

    logic [7:0] test_bytes [] = '{
8'h97, 8'h11, 8'h00, 8'h04, 8'h93, 8'h81, 8'h01, 8'h80, 8'h17, 8'h01, 8'h40, 8'h04, 8'h13, 8'h01, 8'h81, 8'hFF,
8'h13, 8'h05, 8'hC0, 8'h35, 8'h97, 8'h05, 8'h00, 8'h04, 8'h93, 8'h85, 8'hC5, 8'hFE, 8'h17, 8'h06, 8'h00, 8'h04,
8'h13, 8'h06, 8'h46, 8'hFE, 8'h63, 8'hDC, 8'hC5, 8'h00, 8'h83, 8'h22, 8'h05, 8'h00, 8'h23, 8'hA0, 8'h55, 8'h00,
8'h13, 8'h05, 8'h45, 8'h00, 8'h93, 8'h85, 8'h45, 8'h00, 8'h6F, 8'hF0, 8'hDF, 8'hFE, 8'h97, 8'h02, 8'h00, 8'h04,
8'h93, 8'h82, 8'h42, 8'hFC, 8'h17, 8'h03, 8'h00, 8'h04, 8'h13, 8'h03, 8'hC3, 8'hFB, 8'h63, 8'hD8, 8'h62, 8'h00,
8'h23, 8'hA0, 8'h02, 8'h00, 8'h93, 8'h82, 8'h42, 8'h00, 8'h6F, 8'hF0, 8'h5F, 8'hFF, 8'hEF, 8'h00, 8'h80, 8'h27,
8'h6F, 8'h00, 8'h00, 8'h00, 8'h93, 8'h07, 8'hF0, 8'h4F, 8'h63, 8'hE6, 8'hA7, 8'h02, 8'h93, 8'h07, 8'hF0, 8'h2C,
8'h63, 8'hE2, 8'hB7, 8'h02, 8'h93, 8'h97, 8'h25, 8'h00, 8'hB3, 8'h87, 8'hB7, 8'h00, 8'h93, 8'h97, 8'h87, 8'h00,
8'hB3, 8'h87, 8'hA7, 8'h00, 8'h93, 8'h97, 8'h27, 8'h00, 8'h37, 8'h07, 8'hC0, 8'h0F, 8'hB3, 8'h07, 8'hF7, 8'h00,
8'h23, 8'hA0, 8'hC7, 8'h00, 8'h67, 8'h80, 8'h00, 8'h00, 8'h37, 8'h17, 8'hC0, 8'h0F, 8'hB7, 8'hF5, 8'hFF, 8'hFF,
8'h37, 8'h16, 8'h00, 8'h00, 8'hB7, 8'h86, 8'hC0, 8'h0F, 8'h13, 8'h07, 8'h07, 8'h40, 8'h93, 8'h85, 8'h05, 8'hC0,
8'h13, 8'h06, 8'h06, 8'h40, 8'h93, 8'h86, 8'h06, 8'h80, 8'hB3, 8'h07, 8'hB7, 8'h00, 8'h23, 8'hA0, 8'hA7, 8'h00,
8'h93, 8'h87, 8'h47, 8'h00, 8'hE3, 8'h9C, 8'hE7, 8'hFE, 8'h33, 8'h87, 8'hC7, 8'h00, 8'hE3, 8'h16, 8'hD7, 8'hFE,
8'h67, 8'h80, 8'h00, 8'h00, 8'h13, 8'h01, 8'h01, 8'hFA, 8'h23, 8'h22, 8'h51, 8'h05, 8'h23, 8'h2A, 8'h91, 8'h03,
8'h93, 8'h0A, 8'h05, 8'h00, 8'h93, 8'h8C, 8'h05, 8'h00, 8'h13, 8'h05, 8'h06, 8'h00, 8'h93, 8'h05, 8'h06, 8'h00,
8'h23, 8'h26, 8'h31, 8'h05, 8'h23, 8'h2C, 8'h81, 8'h03, 8'h23, 8'h2E, 8'h11, 8'h04, 8'h13, 8'h0C, 8'h06, 8'h00,
8'h23, 8'h2E, 8'hD1, 8'h00, 8'hEF, 8'h00, 8'h40, 8'h23, 8'hB3, 8'h89, 8'h8C, 8'h41, 8'hB3, 8'h07, 8'h9C, 8'h01,
8'h63, 8'hCC, 8'h37, 8'h11, 8'h23, 8'h2A, 8'h91, 8'h04, 8'h93, 8'h04, 8'h10, 8'h00, 8'hB3, 8'h86, 8'h94, 8'h41,
8'h33, 8'h87, 8'h8A, 8'h41, 8'hB3, 8'h87, 8'hF6, 8'h00, 8'h23, 8'h28, 8'hE1, 8'h00, 8'h23, 8'h2A, 8'hF1, 8'h00,
8'h13, 8'h17, 8'h27, 8'h00, 8'hB7, 8'h07, 8'hC0, 8'h0F, 8'hB3, 8'h07, 8'hF7, 8'h00, 8'h23, 8'h24, 8'h41, 8'h05,
8'h13, 8'h9A, 8'h29, 8'h00, 8'h33, 8'h0A, 8'h3A, 8'h01, 8'h23, 8'h2C, 8'hF1, 8'h00, 8'hB3, 8'h07, 8'h5C, 8'h01,
8'h23, 8'h28, 8'h21, 8'h05, 8'h23, 8'h20, 8'h61, 8'h05, 8'h23, 8'h2C, 8'h81, 8'h04, 8'h23, 8'h2E, 8'h71, 8'h03,
8'h23, 8'h28, 8'hA1, 8'h03, 8'h23, 8'h26, 8'hB1, 8'h03, 8'h13, 8'h09, 8'h05, 8'h00, 8'h13, 8'h1A, 8'h8A, 8'h00,
8'hB3, 8'h89, 8'h99, 8'h41, 8'h23, 8'h26, 8'hF1, 8'h00, 8'hB3, 8'h04, 8'h9C, 8'h00, 8'h13, 8'h0B, 8'hF0, 8'h4F,
8'h83, 8'h27, 8'hC1, 8'h00, 8'h03, 8'h27, 8'h01, 8'h01, 8'h63, 8'hC8, 8'hE7, 8'h06, 8'h93, 8'h85, 8'h09, 8'h00,
8'h13, 8'h85, 8'h09, 8'h00, 8'hEF, 8'h00, 8'h40, 8'h1A, 8'h03, 8'h27, 8'h81, 8'h01, 8'h93, 8'h17, 8'h2A, 8'h00,
8'h13, 8'h04, 8'h05, 8'h00, 8'h33, 8'h0D, 8'h80, 8'h41, 8'hB3, 8'h0D, 8'hF7, 8'h00, 8'hB3, 8'h8B, 8'h99, 8'h01,
8'h6F, 8'h00, 8'h00, 8'h01, 8'h13, 8'h0D, 8'h1D, 8'h00, 8'h93, 8'h8D, 8'h4D, 8'h00, 8'h63, 8'h0E, 8'h9D, 8'h02,
8'h93, 8'h05, 8'h0D, 8'h00, 8'h13, 8'h05, 8'h0D, 8'h00, 8'hEF, 8'h00, 8'h00, 8'h17, 8'h33, 8'h05, 8'h85, 8'h00,
8'hE3, 8'h42, 8'hA9, 8'hFE, 8'h33, 8'h07, 8'h5D, 8'h01, 8'hE3, 8'h6E, 8'hEB, 8'hFC, 8'h93, 8'h07, 8'hF0, 8'h2C,
8'hE3, 8'hEA, 8'h77, 8'hFD, 8'h83, 8'h27, 8'hC1, 8'h01, 8'h13, 8'h0D, 8'h1D, 8'h00, 8'h93, 8'h8D, 8'h4D, 8'h00,
8'h23, 8'hAE, 8'hFD, 8'hFE, 8'hE3, 8'h16, 8'h9D, 8'hFC, 8'h83, 8'h27, 8'h41, 8'h01, 8'h93, 8'h89, 8'h19, 8'h00,
8'h13, 8'h0A, 8'h0A, 8'h50, 8'hE3, 8'h9E, 8'hF9, 8'hF6, 8'h03, 8'h24, 8'h81, 8'h05, 8'h83, 8'h24, 8'h41, 8'h05,
8'h03, 8'h29, 8'h01, 8'h05, 8'h03, 8'h2A, 8'h81, 8'h04, 8'h03, 8'h2B, 8'h01, 8'h04, 8'h83, 8'h2B, 8'hC1, 8'h03,
8'h03, 8'h2D, 8'h01, 8'h03, 8'h83, 8'h2D, 8'hC1, 8'h02, 8'h83, 8'h20, 8'hC1, 8'h05, 8'h83, 8'h29, 8'hC1, 8'h04,
8'h83, 8'h2A, 8'h41, 8'h04, 8'h03, 8'h2C, 8'h81, 8'h03, 8'h83, 8'h2C, 8'h41, 8'h03, 8'h13, 8'h01, 8'h01, 8'h06,
8'h67, 8'h80, 8'h00, 8'h00, 8'h33, 8'h8F, 8'hD5, 8'h00, 8'h63, 8'h52, 8'hD0, 8'h08, 8'h93, 8'h07, 8'hF0, 8'h2C,
8'h63, 8'hCE, 8'hB7, 8'h06, 8'h13, 8'h9E, 8'h25, 8'h00, 8'h33, 8'h0E, 8'hBE, 8'h00, 8'h93, 8'h1E, 8'h25, 8'h00,
8'hB7, 8'h07, 8'hC0, 8'h0F, 8'h33, 8'h08, 8'hC5, 8'h00, 8'h13, 8'h1E, 8'h8E, 8'h00, 8'h93, 8'h08, 8'hF0, 8'h4F,
8'hB3, 8'h8E, 8'hFE, 8'h00, 8'h13, 8'h03, 8'h00, 8'h50, 8'h93, 8'h0F, 8'h00, 8'h2D, 8'h63, 8'h50, 8'hC0, 8'h04,
8'h93, 8'h16, 8'h2E, 8'h00, 8'hB3, 8'h86, 8'hDE, 8'h00, 8'h93, 8'h07, 8'h05, 8'h00, 8'h63, 8'hC8, 8'hA8, 8'h02,
8'h63, 8'hFA, 8'hF8, 8'h00, 8'h93, 8'h87, 8'h17, 8'h00, 8'h63, 8'hD2, 8'h07, 8'h03, 8'h93, 8'h86, 8'h46, 8'h00,
8'hE3, 8'hEA, 8'hF8, 8'hFE, 8'h93, 8'h87, 8'h17, 8'h00, 8'h63, 8'hC4, 8'h05, 8'h00, 8'h23, 8'hA0, 8'hE6, 8'h00,
8'h63, 8'hD6, 8'h07, 8'h01, 8'h93, 8'h86, 8'h46, 8'h00, 8'hE3, 8'h96, 8'h67, 8'hFE, 8'h93, 8'h85, 8'h15, 8'h00,
8'h63, 8'hD8, 8'hE5, 8'h01, 8'h13, 8'h0E, 8'h0E, 8'h50, 8'hE3, 8'h9A, 8'hF5, 8'hFB, 8'h67, 8'h80, 8'h00, 8'h00,
8'h67, 8'h80, 8'h00, 8'h00, 8'h13, 8'h01, 8'h01, 8'hFF, 8'h13, 8'h05, 8'h00, 8'h00, 8'h23, 8'h26, 8'h11, 8'h00,
8'hEF, 8'hF0, 8'h9F, 8'hDB, 8'hB7, 8'h06, 8'hFF, 8'h00, 8'h13, 8'h06, 8'h20, 8'h00, 8'h93, 8'h05, 8'h80, 8'h16,
8'h13, 8'h05, 8'h00, 8'h14, 8'hEF, 8'hF0, 8'h1F, 8'hDE, 8'hB7, 8'h06, 8'h01, 8'h00, 8'h93, 8'h86, 8'h06, 8'hF0,
8'h13, 8'h06, 8'h20, 8'h00, 8'h93, 8'h05, 8'h80, 8'h16, 8'h13, 8'h05, 8'h00, 8'h28, 8'hEF, 8'hF0, 8'h9F, 8'hDC,
8'h93, 8'h06, 8'hF0, 8'h0F, 8'h13, 8'h06, 8'h20, 8'h00, 8'h93, 8'h05, 8'h80, 8'h16, 8'h13, 8'h05, 8'h00, 8'h3C,
8'hEF, 8'hF0, 8'h5F, 8'hDB, 8'h37, 8'hC7, 8'h11, 8'h00, 8'hB7, 8'h17, 8'hE7, 8'h0F, 8'h13, 8'h07, 8'h97, 8'hB9,
8'h23, 8'hA8, 8'hE7, 8'h7C, 8'h6F, 8'h00, 8'h00, 8'h00, 8'h13, 8'h06, 8'h05, 8'h00, 8'h13, 8'h05, 8'h00, 8'h00,
8'h93, 8'hF6, 8'h15, 8'h00, 8'h63, 8'h84, 8'h06, 8'h00, 8'h33, 8'h05, 8'hC5, 8'h00, 8'h93, 8'hD5, 8'h15, 8'h00,
8'h13, 8'h16, 8'h16, 8'h00, 8'hE3, 8'h96, 8'h05, 8'hFE, 8'h67, 8'h80, 8'h00, 8'h00
};

    task load_program(

    ); 
        // for(int i = 0; i < $size(test_program); i = i + 1) begin
        //     load_data(.data(test_program[i]), .addr(32'(i * 4)));
        // end
        logic [32:0] word_val;
        logic [7:0] b0, b1, b2, b3;
        int i;
        for (i = 0; i < $size(test_bytes); i = i + 4) begin
            b0 = test_bytes[i];
            b1 = (i + 1 < $size(test_bytes)) ? test_bytes[i+1] : 8'h00;
            b2 = (i + 2 < $size(test_bytes)) ? test_bytes[i+2] : 8'h00;
            b3 = (i + 3 < $size(test_bytes)) ? test_bytes[i+3] : 8'h00;

            // Little-endian assembly: {b3, b2, b1, b0}
            word_val = {b3, b2, b1, b0};

            load_data(.data(word_val), .addr(32'(i)));
        end

        repeat(16) begin
            load_data(.data(32'h0000006F), .addr(32'(i)));
            i = i+4;
        end
    endtask

    task cache_respond(

    );
        @(negedge clk);
        if(video_data) begin
            @(negedge clk);
            $display("[%0t ns] writing pixel data %h to addr %h",$time ,data_data_in[31:0], data_addr);
            repeat(2) @(posedge clk);
            data_write_done = HIGH;
            @(posedge clk);
            data_write_done = LOW;
        end

        if(data_wr_miss | data_rd_miss) begin
            @(posedge clk);
            if(data_dirty) begin
                memory[data_addr_dirty[31:6]] = data_data_in;
                $display("[%0t ] Writing to address %0h.", $time, {data_addr_dirty[31:6], 6'b0});
            end
            @(posedge clk);
            if (!memory.exists(data_addr[31:6])) begin
                $display("[%0t ] Attempted to read unwritten empty address %0h.", $time, {data_addr[31:6], 6'b0});
                data_data_out = '0;
            end else begin
                data_data_out = memory[data_addr[31:6]];
            end
            data_write_done = HIGH;
            @(posedge clk);
            data_write_done = LOW;
            if(!video_data) begin
                repeat(2) @(posedge clk);
                data_read_done = HIGH;
                @(posedge clk);
                data_read_done = LOW;
            end
        end

        if(ins_rd_miss) begin
            @(posedge clk);
            $display("instruction rd miss at %t", $time);
            repeat(2) @(posedge clk);
            ins_data_out = 32'h0000_0000;
            ins_read_done = HIGH;
            @(posedge clk);
        end

        // if(data_rd_miss) begin
        //     repeat(2) @(posedge clk);
        //     data_data_out = 32'h5555_5555;
        //     repeat(2) @(posedge clk);
        //     data_read_done = HIGH;
        //     @(posedge clk);
        //     data_read_done = LOW;
        // end
    endtask

    task run_startup(

    );
        int addr = 0;
        start_write_en = HIGH;
        start_valid = LOW;
        start_data = '0;
        for(addr = 0; addr < 1024; addr++) begin
            start_addr = {16'b0, 10'(addr), 6'b0};
            repeat(2) @(posedge clk);
        end
    endtask

    initial begin
        clk = LOW;
        nrst = LOW;
        ins_read_done = LOW;
        data_read_done = LOW;
        data_write_done = LOW;
        start_valid = LOW;
        start_write_en = LOW;
        start_done = LOW;

        data_data_in = LOW;

        repeat(2) @(posedge clk);

        nrst = HIGH;

        repeat(2) @(posedge clk);

        run_startup();

        load_program();

        repeat(2) @(posedge clk);

        start_done = HIGH;

        repeat(100000000) begin
            @(posedge clk);
            cache_respond();
        end

        repeat(10) @(posedge clk);

        $display("[%0t ns] Testbench complete.", $time);
        $finish;
    end
endmodule
