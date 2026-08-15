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

    logic [31:0] ins_addr, data_addr, start_addr, start_data;
    logic [511:0] ins_data_out, data_data_in, data_data_out;

    CPU_top DUT(.*);

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

    task load_program(

    ); 
        for(int i = 0; i < $size(test_program); i = i + 1) begin
            load_data(.data(test_program[i]), .addr(32'(i * 4)));
        end
    endtask

    task cache_respond(

    );
        if(video_data) begin
            $display("writing pixel data %h to addr %h", data_data_in[31:0], data_addr);
            repeat(2) @(posedge clk);
            data_write_done = HIGH;
            @(posedge clk);
            data_write_done = LOW;
        end

        if(data_wr_miss) begin
            
            repeat(2) @(posedge clk);
            data_data_out = 32'h5555_5555;
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
            ins_data_out = 32'h9999_9999;
            ins_read_done = HIGH;
            repeat(10) @(posedge clk);
            $finish;
        end

        if(data_rd_miss) begin
            repeat(2) @(posedge clk);
            data_data_out = 32'h5555_5555;
            repeat(2) @(posedge clk);
            data_read_done = HIGH;
            @(posedge clk);
            data_read_done = LOW;
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

        load_program();

        repeat(2) @(posedge clk);

        start_done = HIGH;

        repeat(50000) begin
            @(posedge clk);
            cache_respond;
        end

        repeat(10) @(posedge clk);

        $display("[%0t ns] Testbench complete.", $time);
        $finish;
    end
endmodule
