`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2026 04:48:16 PM
// Design Name: 
// Module Name: bram_tb
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

`include "vivado_interfaces.svh"

module bram_tb(

    );
    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;
    localparam int period = 10;

    logic clk, ena;
    logic [535:0] dina, douta;
    logic [8:0] addra;
    logic [66:0] wea;

    always begin
        #(period);
        clk = ~clk;
    end

    blk_mem_gen_2_sv your_instance_name (
        .clka(clk), // input wire clka
        .ena(ena), // input wire ena
        .wea(wea), // input wire [66:0] wea
        .addra(addra), // input wire [8:0] addra
        .dina(dina), // input wire [535:0] dina
        .douta(douta) // output wire [535:0] douta
    );

    string test_case;
    int test_num;
    int tests_passed;

    initial begin
        test_case = "writing first registers";
        test_num = 0;
        tests_passed = 0;

        clk = LOW;
        ena = HIGH;
        wea = '1;
        addra = '0;
        dina = '0;

        @(posedge clk);
        for(int i = 0; i < 10; i++) begin
            addra = 9'(i);
            dina = 536'(i);
            @(posedge clk);
        end

        @(posedge clk);
        

        test_case = "read before write";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        @(posedge clk);
        
        addra = 9'd2;
        dina = {134{4'hc}};
        @(posedge clk);

        if(douta != '0) begin
            $display("failed read before write 1");
        end

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


        $display("Finished @ %t. %d/%d passed", $time, tests_passed, test_num);
        $finish;
    end
endmodule
