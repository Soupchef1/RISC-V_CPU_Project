`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 03:38:26 PM
// Design Name: 
// Module Name: HDMI_tb
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


module HDMI_tb ();

    localparam CLK_PERIOD = 13.49;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    logic pixel_clk;
    logic serial_clk;
    logic nrst;

    logic vid_active;
    logic [31:0] vid_data;
    logic hsync;
    logic vsync;
    logic vid_field_id;
    logic vid_hblank;
    logic vid_vblank;

    logic [2:0] hdmi_out_p; //order MSB to LSB: RED, GREEN, BLUE.
    logic [2:0] hdmi_out_n;
    logic hdmi_out_clk_p;
    logic hdmi_out_clk_n;

    HDMI DUT (.*);

    task reset_dut;
    begin
        nrst = LOW;
        @(posedge pixel_clk);
        @(posedge pixel_clk);
        nrst = HIGH;
        @(posedge pixel_clk);
        @(posedge pixel_clk);
    end
    endtask    

    string test_case;
    int test_num;
    int tests_passed;

    always begin
        #(CLK_PERIOD/2.0); 
        pixel_clk = ~pixel_clk;
    end

    always begin
        #(CLK_PERIOD/10.0);
        serial_clk = ~serial_clk;
    end

    initial begin

        pixel_clk = LOW;
        serial_clk = LOW;
        vid_active = LOW;
        vid_data = 32'h00000000;
        hsync = LOW;
        vsync = LOW;
        vid_field_id = LOW;
        vid_hblank = LOW;
        vid_vblank = LOW;

        test_case = "reset";
        $display("\n\nTesting: %s @ %t", test_case, $time);
        reset_dut();

        @(posedge pixel_clk);
        @(posedge pixel_clk);


        test_case = "Vertical & Horizontal Blanking";
        $display("Testing: %s @ %t", test_case, $time);
        vid_active = LOW;
        vid_hblank = HIGH;
        vid_vblank = HIGH;
        vsync = HIGH;
        hsync = HIGH;

        @(posedge pixel_clk);
        @(posedge pixel_clk);

        test_case = "Active Video - RED";
        $display("Testing: %s @ %t", test_case, $time);
        vid_active = HIGH;
        vid_data = 32'h00FF0000; 
        @(posedge pixel_clk);


        test_case = "Active Video - GREEN";
        $display("Testing: %s @ %t", test_case, $time);
        vid_data = 32'h0000FF00; 
        @(posedge pixel_clk);

        test_case = "Active Video - BLUE";
        $display("Testing: %s @ %t", test_case, $time);
        vid_data = 32'h000000FF; 
        @(posedge pixel_clk);

        test_case = "Active Video - WHITE";
        $display("Testing: %s @ %t", test_case, $time);
        vid_data = 32'h00FFFFFF; 
        @(posedge pixel_clk);

        $display("\nSimulation Complete @ %t\n", $time);
        
        $finish;

    end


endmodule
