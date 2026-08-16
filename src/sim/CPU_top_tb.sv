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
        32'h04001197,
        32'h80018193,
        32'h04400117,
        32'hFF810113,
        32'h2C000513,
        32'h04000597,
        32'hFEC58593,
        32'h04000617,
        32'hFE460613,
        32'h00C5DC63,
        32'h00052283,
        32'h0055A023,
        32'h00450513,
        32'h00458593,
        32'hFEDFF06F,
        32'h04000297,
        32'hFC428293,
        32'h04000317,
        32'hFBC30313,
        32'h0062D863,
        32'h0002A023,
        32'h00428293,
        32'hFF5FF06F,
        32'h1EC000EF,
        32'h0000006F,
        32'h4FF00793,
        32'h02A7E663,
        32'h2CF00793,
        32'h02B7E263,
        32'h00259793,
        32'h00B787B3,
        32'h00879793,
        32'h00A787B3,
        32'h00279793,
        32'h0FC00737,
        32'h00F707B3,
        32'h00C7A023,
        32'h00008067,
        32'h0FC01737,
        32'hFFFFF837,
        32'h000015B7,
        32'h0FF85637,
        32'h00050693,
        32'h40070713,
        32'hC0080813,
        32'h40058593,
        32'h40060613,
        32'h010707B3,
        32'h00D7A023,
        32'h00478793,
        32'hFEE79CE3,
        32'h00B78733,
        32'hFEC716E3,
        32'h00008067,
        32'hFA010113,
        32'h05512223,
        32'h03912A23,
        32'h00050A93,
        32'h00058C93,
        32'h00060513,
        32'h00060593,
        32'h05312623,
        32'h03812C23,
        32'h04112E23,
        32'h00060C13,
        32'h00D12E23,
        32'h194000EF,
        32'h418C89B3,
        32'h019C07B3,
        32'h1137CC63,
        32'h04912A23,
        32'h00100493,
        32'h419486B3,
        32'h418A8733,
        32'h00F687B3,
        32'h00E12823,
        32'h00F12A23,
        32'h00271713,
        32'h0FC007B7,
        32'h00F707B3,
        32'h05412423,
        32'h00299A13,
        32'h013A0A33,
        32'h00F12C23,
        32'h015C07B3,
        32'h05212823,
        32'h05612023,
        32'h04812C23,
        32'h03712E23,
        32'h03A12823,
        32'h03B12623,
        32'h00050913,
        32'h008A1A13,
        32'h419989B3,
        32'h00F12623,
        32'h009C04B3,
        32'h4FF00B13,
        32'h00C12783,
        32'h01012703,
        32'h06E7C863,
        32'h00098593,
        32'h00098513,
        32'h104000EF,
        32'h01812703,
        32'h002A1793,
        32'h00050413,
        32'h41800D33,
        32'h00F70DB3,
        32'h01998BB3,
        32'h0100006F,
        32'h001D0D13,
        32'h004D8D93,
        32'h029D0E63,
        32'h000D0593,
        32'h000D0513,
        32'h0D0000EF,
        32'h00850533,
        32'hFEA942E3,
        32'h015D0733,
        32'hFCEB6EE3,
        32'h2CF00793,
        32'hFD77EAE3,
        32'h01C12783,
        32'h001D0D13,
        32'h004D8D93,
        32'hFEFDAE23,
        32'hFC9D16E3,
        32'h01412783,
        32'h00198993,
        32'h500A0A13,
        32'hF6F99EE3,
        32'h05812403,
        32'h05412483,
        32'h05012903,
        32'h04812A03,
        32'h04012B03,
        32'h03C12B83,
        32'h03012D03,
        32'h02C12D83,
        32'h05C12083,
        32'h04C12983,
        32'h04412A83,
        32'h03812C03,
        32'h03412C83,
        32'h06010113,
        32'h00008067,
        32'hFF010113,
        32'h00000513,
        32'h00112623,
        32'hE45FF0EF,
        32'h00FF06B7,
        32'h05000613,
        32'h16800593,
        32'h14000513,
        32'hE71FF0EF,
        32'h000106B7,
        32'hF0068693,
        32'h05000613,
        32'h16800593,
        32'h28000513,
        32'hE59FF0EF,
        32'h0FF00693,
        32'h05000613,
        32'h16800593,
        32'h3C000513,
        32'hE45FF0EF,
        32'h0000006F,
        32'h00050613,
        32'h00000513,
        32'h0015F693,
        32'h00068463,
        32'h00C50533,
        32'h0015D593,
        32'h00161613,
        32'hFE0596E3,
        32'h00008067
    };

    logic [7:0] test_bytes [] = '{
        32'h97, 32'h11, 32'h00, 32'h04, 32'h93, 32'h81, 32'h01, 32'h80, 32'h17, 32'h01, 32'h40, 32'h04, 32'h13, 32'h01, 32'h81, 32'hFF,
32'h13, 32'h05, 32'h80, 32'h1C, 32'h97, 32'h05, 32'h00, 32'h04, 32'h93, 32'h85, 32'hC5, 32'hFE, 32'h17, 32'h06, 32'h00, 32'h04,
32'h13, 32'h06, 32'h46, 32'hFE, 32'h63, 32'hDC, 32'hC5, 32'h00, 32'h83, 32'h22, 32'h05, 32'h00, 32'h23, 32'hA0, 32'h55, 32'h00,
32'h13, 32'h05, 32'h45, 32'h00, 32'h93, 32'h85, 32'h45, 32'h00, 32'h6F, 32'hF0, 32'hDF, 32'hFE, 32'h97, 32'h02, 32'h00, 32'h04,
32'h93, 32'h82, 32'h42, 32'hFC, 32'h17, 32'h03, 32'h00, 32'h04, 32'h13, 32'h03, 32'hC3, 32'hFB, 32'h63, 32'hD8, 32'h62, 32'h00,
32'h23, 32'hA0, 32'h02, 32'h00, 32'h93, 32'h82, 32'h42, 32'h00, 32'h6F, 32'hF0, 32'h5F, 32'hFF, 32'hEF, 32'h00, 32'hC0, 32'h10,
32'h6F, 32'h00, 32'h00, 32'h00, 32'h93, 32'h07, 32'hF0, 32'h4F, 32'h63, 32'hE6, 32'hA7, 32'h02, 32'h93, 32'h07, 32'hF0, 32'h2C,
32'h63, 32'hE2, 32'hB7, 32'h02, 32'h93, 32'h97, 32'h25, 32'h00, 32'hB3, 32'h87, 32'hB7, 32'h00, 32'h93, 32'h97, 32'h87, 32'h00,
32'hB3, 32'h87, 32'hA7, 32'h00, 32'h93, 32'h97, 32'h27, 32'h00, 32'h37, 32'h07, 32'h80, 32'h0F, 32'hB3, 32'h07, 32'hF7, 32'h00,
32'h23, 32'hA0, 32'hC7, 32'h00, 32'h67, 32'h80, 32'h00, 32'h00, 32'h37, 32'h17, 32'h80, 32'h0F, 32'h37, 32'hF8, 32'hFF, 32'hFF,
32'hB7, 32'h15, 32'h00, 32'h00, 32'h37, 32'hA6, 32'h81, 32'h0F, 32'h93, 32'h06, 32'h05, 32'h00, 32'h13, 32'h07, 32'h07, 32'h40,
32'h13, 32'h08, 32'h08, 32'hC0, 32'h93, 32'h85, 32'h05, 32'h40, 32'h13, 32'h06, 32'h06, 32'h40, 32'hB3, 32'h07, 32'h07, 32'h01,
32'h23, 32'hA0, 32'hD7, 32'h00, 32'h93, 32'h87, 32'h47, 32'h00, 32'hE3, 32'h9C, 32'hE7, 32'hFE, 32'h33, 32'h87, 32'hB7, 32'h00,
32'hE3, 32'h16, 32'hC7, 32'hFE, 32'h67, 32'h80, 32'h00, 32'h00, 32'h33, 32'h8F, 32'hD5, 32'h00, 32'h63, 32'h52, 32'hD0, 32'h08,
32'h93, 32'h07, 32'hF0, 32'h2C, 32'h63, 32'hCE, 32'hB7, 32'h06, 32'h13, 32'h9E, 32'h25, 32'h00, 32'h33, 32'h0E, 32'hBE, 32'h00,
32'h93, 32'h1E, 32'h25, 32'h00, 32'hB7, 32'h07, 32'h80, 32'h0F, 32'h33, 32'h08, 32'hC5, 32'h00, 32'h13, 32'h1E, 32'h8E, 32'h00,
32'h93, 32'h08, 32'hF0, 32'h4F, 32'hB3, 32'h8E, 32'hFE, 32'h00, 32'h13, 32'h03, 32'h00, 32'h50, 32'h93, 32'h0F, 32'h00, 32'h2D,
32'h63, 32'h50, 32'hC0, 32'h04, 32'h93, 32'h16, 32'h2E, 32'h00, 32'hB3, 32'h86, 32'hDE, 32'h00, 32'h93, 32'h07, 32'h05, 32'h00,
32'h63, 32'hC8, 32'hA8, 32'h02, 32'h63, 32'hFA, 32'hF8, 32'h00, 32'h93, 32'h87, 32'h17, 32'h00, 32'h63, 32'hD2, 32'h07, 32'h03,
32'h93, 32'h86, 32'h46, 32'h00, 32'hE3, 32'hEA, 32'hF8, 32'hFE, 32'h93, 32'h87, 32'h17, 32'h00, 32'h63, 32'hC4, 32'h05, 32'h00,
32'h23, 32'hA0, 32'hE6, 32'h00, 32'h63, 32'hD6, 32'h07, 32'h01, 32'h93, 32'h86, 32'h46, 32'h00, 32'hE3, 32'h96, 32'h67, 32'hFE,
32'h93, 32'h85, 32'h15, 32'h00, 32'h63, 32'hD8, 32'hE5, 32'h01, 32'h13, 32'h0E, 32'h0E, 32'h50, 32'hE3, 32'h9A, 32'hF5, 32'hFB,
32'h67, 32'h80, 32'h00, 32'h00, 32'h67, 32'h80, 32'h00, 32'h00, 32'h13, 32'h01, 32'h01, 32'hFF, 32'h13, 32'h05, 32'h00, 32'h00,
32'h23, 32'h26, 32'h11, 32'h00, 32'hEF, 32'hF0, 32'h5F, 32'hF2, 32'h37, 32'h07, 32'hFF, 32'h00, 32'h93, 32'h06, 32'h00, 32'h05,
32'h13, 32'h06, 32'h40, 32'h1F, 32'h93, 32'h05, 32'hC0, 32'h12, 32'h13, 32'h05, 32'h00, 32'h14, 32'hEF, 32'hF0, 32'hDF, 32'hF4,
32'h13, 32'h07, 32'hF0, 32'h0F, 32'h93, 32'h06, 32'h00, 32'h05, 32'h13, 32'h06, 32'h40, 32'h1F, 32'h93, 32'h05, 32'h80, 32'h0C,
32'h13, 32'h05, 32'h00, 32'h28, 32'hEF, 32'hF0, 32'h5F, 32'hF3, 32'h37, 32'h07, 32'h01, 32'h00, 32'h13, 32'h07, 32'h07, 32'hF0,
32'h93, 32'h06, 32'h00, 32'h05, 32'h13, 32'h06, 32'h40, 32'h1F, 32'h93, 32'h05, 32'h40, 32'h06, 32'h13, 32'h05, 32'h00, 32'h3C,
32'hEF, 32'hF0, 32'h9F, 32'hF1, 32'h6F, 32'h00, 32'h00, 32'h00
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
            $display("[%0t ns] writing pixel data %h to addr %h",$time ,data_data_in[31:0], data_addr);
            repeat(2) @(posedge clk);
            data_write_done = HIGH;
            @(posedge clk);
            data_write_done = LOW;
        end

        if(data_wr_miss | data_rd_miss) begin
            if(data_dirty) begin
                memory[data_addr_dirty] = data_data_in;
                $display("[%0t ] Writing to address %0h.", $time, data_addr_dirty);
            end
            @(posedge clk);
            if (!memory.exists(data_addr)) begin
                $display("[%0t ] Attempted to read unwritten empty address %0h.", $time, data_addr);
                data_data_out = '0;
            end else begin
                data_data_out = memory[data_addr];
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
