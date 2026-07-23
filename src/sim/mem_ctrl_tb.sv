`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2026 05:18:05 PM
// Design Name: 
// Module Name: mem_ctrl_tb
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


module mem_ctrl_tb(

    );

    localparam CLK_PERIOD = 10;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;

    logic clk, nrst;

    //instruction
    logic [31:0] ins_addr;
    logic [511:0] ins_data_out; //[511:0] is actual data
    logic ins_rd_miss;

    //data
    logic [31:0] data_addr;
    logic [511:0] data_data_in; //data coming in from cache
    logic [511:0] data_data_out; //correct data going into cache
    logic data_rd_miss;
    logic data_wr_miss;
    logic data_dirty;
    logic video_data;

    //misc.
    logic finish;
    logic ins_read_done;
    logic data_read_done;    //axi shi
    logic [31:0] awaddr;
    logic [7:0] awlen;   //should be 3; cuz its ts + 1 for actual size
    logic [2:0] awsize;  //128 bits 
    logic [1:0] awburst; 
    logic awlock;
    logic [3:0] awcache;
    logic [2:0] awprot;
    logic [3:0] awqos;
    logic awvalid;
    logic awready;

    logic [127:0] wdata;
    logic [15:0] wstrb;
    logic wlast;
    logic wvalid;
    logic wready;

    logic [1:0] bresp;
    logic bvalid;
    logic bready;

    logic [31:0] araddr;
    logic [7:0] arlen;
    logic [2:0] arsize;
    logic [1:0] arburst;
    logic arlock;
    logic [3:0] arcache;
    logic [2:0] arprot;
    logic [3:0] arqos;
    logic arvalid;
    logic arready;
    
    logic [127:0] rdata;
    logic [1:0] rresp;
    logic rlast;
    logic rvalid;
    logic rready;

    Mem_ctrl DUT(.*);

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

    always begin
        #(CLK_PERIOD/2.0); 
        clk = ~clk;
    end

    // test bench signals
    string test_case;
    int test_num;
    int tests_passed;

    // need to drive:
    // clk, nrst, ins_addr, ins_rd_miss, data_addr, data_data_in, data_rd_miss,
    // data_wr_miss, data_dirty, video_data;

    // axi signals to set:
    // awready, wready, bvalid, bresp, arready, rdata, rresp, rlast, rvalid

    int count;

    initial begin
        test_num = 0;
        tests_passed = 0;
        test_case = "Reset";
        clk = LOW;
        nrst = LOW; 
        awready = LOW;
        wready = LOW;
        bvalid = LOW;
        bresp = '0;
        arready = LOW; 
        data_addr = 32'h0001_0000;
        data_data_in = {128'h4, 128'h3, 128'h2, 128'h1};
        ins_addr = 32'h0000_000F;

        rdata = '1;
        rresp = '0;
        rlast = LOW;
        rvalid = LOW;
        
        ins_rd_miss = LOW;
        data_rd_miss = LOW;
        data_wr_miss = LOW;
        data_dirty = LOW;
        video_data = LOW;

        reset_dut();

        test_case = "DATA READ DIRTY + INS READ";
        $display("\n\ntesting: %s @ %t", test_case, $time);
        test_num++;

        count = 0;

        data_rd_miss = HIGH;
        data_dirty = HIGH;
        ins_rd_miss = HIGH;

        awready = HIGH;
        bvalid = HIGH;

        repeat (5) @(negedge clk);

        wready = HIGH;
        @(negedge clk);
        wready = LOW;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        wready = HIGH;
        @(negedge clk);
        wready = LOW;
        @(negedge clk);
        @(negedge clk);
        wready = HIGH;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        

        //first read cycle
        @(negedge clk);
        arready = HIGH;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        arready = LOW;

        rvalid = HIGH;

        while(rlast == LOW) begin
            if(rvalid && rready) begin
                count++;
                rlast = (count == 4) ? HIGH : LOW;
            end
            @(negedge clk);
        end;

        //second read cycle
        rdata = 10;
        count = 0;
        @(posedge arvalid);
        @(negedge clk);
        arready = HIGH;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        rlast = LOW;
        arready = LOW;

        rvalid = HIGH;

        while(rlast == LOW) begin
            if(rvalid && rready) begin
                count++;
                rlast = (count == 4) ? HIGH : LOW;
                rdata++;
            end
            @(negedge clk);
        end;

        $display("Test: %s finished @ %t", test_case, $time);

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        $finish; 
    end
    
endmodule
