`timescale 1ns / 1ps

module tb_top;

    // Inputs
    logic CLK100MHZ;
    logic ck_rst;
    logic start_button;
    logic uart_txd_in;
    logic reset_button;

    // Outputs
    logic [3:0] led;
    logic uart_rxd_out;
    logic [2:0] hdmi_out_p;
    logic [2:0] hdmi_out_n;
    logic hdmi_out_clk_p;
    logic hdmi_out_clk_n;

    // DDR3 SDRAM Interfaces
    wire [15:0] ddr3_sdram_dq;
    wire [1:0]  ddr3_sdram_dqs_p;
    wire [1:0]  ddr3_sdram_dqs_n;
    wire [13:0] ddr3_sdram_addr;
    wire [2:0]  ddr3_sdram_ba;
    wire        ddr3_sdram_ras_n;
    wire        ddr3_sdram_cas_n;
    wire        ddr3_sdram_we_n;
    wire        ddr3_sdram_reset_n;
    wire [0:0]  ddr3_sdram_ck_p;
    wire [0:0]  ddr3_sdram_ck_n;
    wire [0:0]  ddr3_sdram_cke;
    wire [0:0]  ddr3_sdram_cs_n;
    wire [1:0]  ddr3_sdram_dm;
    wire [0:0]  ddr3_sdram_odt;

    //boot
    logic start_done, start_valid, start_write_en, start_finish, start_bvalid;
    logic [31:0] start_data, start_addr;
    logic mig_ready, boot_start;

    // Unit Under Test (UUT)
    top_no_boot uut (
        .CLK100MHZ(CLK100MHZ),
        .ck_rst(ck_rst),
        .start_button(start_button),
        .led(led),
        .uart_txd_in(uart_txd_in),
        .uart_rxd_out(uart_rxd_out),
        .hdmi_out_p(hdmi_out_p),
        .hdmi_out_n(hdmi_out_n),
        .hdmi_out_clk_p(hdmi_out_clk_p),
        .hdmi_out_clk_n(hdmi_out_clk_n),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .*
    );

    ddr3_model ddr3 (
        .rst_n(ddr3_sdram_reset_n),
        .ck(ddr3_sdram_ck_p),
        .ck_n(ddr3_sdram_ck_n),
        .cke(ddr3_sdram_cke),
        .cs_n(ddr3_sdram_cs_n),
        .ras_n(ddr3_sdram_ras_n),
        .cas_n(ddr3_sdram_cas_n),
        .we_n(ddr3_sdram_we_n),
        .dm_tdqs(ddr3_sdram_dm),
        .ba(ddr3_sdram_ba),
        .addr(ddr3_sdram_addr),
        .dq(ddr3_sdram_dq),
        .dqs(ddr3_sdram_dqs_p),
        .dqs_n(ddr3_sdram_dqs_n),
        .tdqs_n(),
        .odt(ddr3_sdram_odt)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 CLK100MHZ = ~CLK100MHZ;

    // UART Bit Rate Configuration
    // Baudrate = 2,000,000 -> Bit Period = 500 ns
    localparam time BIT_PERIOD = 500ns;

    // Program Memory array (Raw bytes from main_test.vh)
    byte test_bytes[] = '{
        32'h97, 32'h11, 32'h00, 32'h04, 32'h93, 32'h81, 32'h01, 32'h80, 32'h17, 32'h01, 32'h40, 32'h04, 32'h13, 32'h01, 32'h81, 32'hFF,
        32'h13, 32'h05, 32'h00, 32'h2C, 32'h97, 32'h05, 32'h00, 32'h04, 32'h93, 32'h85, 32'hC5, 32'hFE, 32'h17, 32'h06, 32'h00, 32'h04,
        32'h13, 32'h06, 32'h46, 32'hFE, 32'h63, 32'hDC, 32'hC5, 32'h00, 32'h83, 32'h22, 32'h05, 32'h00, 32'h23, 32'hA0, 32'h55, 32'h00,
        32'h13, 32'h05, 32'h45, 32'h00, 32'h93, 32'h85, 32'h45, 32'h00, 32'h6F, 32'hF0, 32'hDF, 32'hFE, 32'h97, 32'h02, 32'h00, 32'h04,
        32'h93, 32'h82, 32'h42, 32'hFC, 32'h17, 32'h03, 32'h00, 32'h04, 32'h13, 32'h03, 32'hC3, 32'hFB, 32'h63, 32'hD8, 32'h62, 32'h00,
        32'h23, 32'hA0, 32'h02, 32'h00, 32'h93, 32'h82, 32'h42, 32'h00, 32'h6F, 32'hF0, 32'h5F, 32'hFF, 32'hEF, 32'h00, 32'hC0, 32'h1E,
        32'h6F, 32'h00, 32'h00, 32'h00, 32'h93, 32'h07, 32'hF0, 32'h4F, 32'h63, 32'hE6, 32'hA7, 32'h02, 32'h93, 32'h07, 32'hF0, 32'h2C,
        32'h63, 32'hE2, 32'hB7, 32'h02, 32'h93, 32'h97, 32'h25, 32'h00, 32'hB3, 32'h87, 32'hB7, 32'h00, 32'h93, 32'h97, 32'h87, 32'h00,
        32'hB3, 32'h87, 32'hA7, 32'h00, 32'h93, 32'h97, 32'h27, 32'h00, 32'h37, 32'h07, 32'h80, 32'h0F, 32'hB3, 32'h07, 32'hF7, 32'h00,
        32'h23, 32'hA0, 32'hC7, 32'h00, 32'h67, 32'h80, 32'h00, 32'h00, 32'h37, 32'h17, 32'h80, 32'h0F, 32'h37, 32'hF8, 32'hFF, 32'hFF,
        32'hB7, 32'h15, 32'h00, 32'h00, 32'h37, 32'h56, 32'hB8, 32'h0F, 32'h93, 32'h06, 32'h05, 32'h00, 32'h13, 32'h07, 32'h07, 32'h40,
        32'h13, 32'h08, 32'h08, 32'hC0, 32'h93, 32'h85, 32'h05, 32'h40, 32'h13, 32'h06, 32'h06, 32'h40, 32'hB3, 32'h07, 32'h07, 32'h01,
        32'h23, 32'hA0, 32'hD7, 32'h00, 32'h93, 32'h87, 32'h47, 32'h00, 32'hE3, 32'h9C, 32'hE7, 32'hFE, 32'h33, 32'h87, 32'hB7, 32'h00,
        32'hE3, 32'h16, 32'hC7, 32'hFE, 32'h67, 32'h80, 32'h00, 32'h00, 32'h13, 32'h01, 32'h01, 32'hFA, 32'h23, 32'h22, 32'h51, 32'h05,
        32'h23, 32'h2A, 32'h91, 32'h03, 32'h93, 32'h0A, 32'h05, 32'h00, 32'h93, 32'h8C, 32'h05, 32'h00, 32'h13, 32'h05, 32'h06, 32'h00,
        32'h93, 32'h05, 32'h06, 32'h00, 32'h23, 32'h26, 32'h31, 32'h05, 32'h23, 32'h2C, 32'h81, 32'h03, 32'h23, 32'h2E, 32'h11, 32'h04,
        32'h13, 32'h0C, 32'h06, 32'h00, 32'h23, 32'h2E, 32'hD1, 32'h00, 32'hEF, 32'h00, 32'h40, 32'h19, 32'hB3, 32'h89, 32'h8C, 32'h41,
        32'hB3, 32'h07, 32'h9C, 32'h01, 32'h63, 32'hCC, 32'h37, 32'h11, 32'h23, 32'h2A, 32'h91, 32'h04, 32'h93, 32'h04, 32'h10, 32'h00,
        32'hB3, 32'h86, 32'h94, 32'h41, 32'h33, 32'h87, 32'h8A, 32'h41, 32'hB3, 32'h87, 32'hF6, 32'h00, 32'h23, 32'h28, 32'hE1, 32'h00,
        32'h23, 32'h2A, 32'hF1, 32'h00, 32'h13, 32'h17, 32'h27, 32'h00, 32'hB7, 32'h07, 32'h80, 32'h0F, 32'hB3, 32'h07, 32'hF7, 32'h00,
        32'h23, 32'h24, 32'h41, 32'h05, 32'h13, 32'h9A, 32'h29, 32'h00, 32'h33, 32'h0A, 32'h3A, 32'h01, 32'h23, 32'h2C, 32'hF1, 32'h00,
        32'hB3, 32'h07, 32'h5C, 32'h01, 32'h23, 32'h28, 32'h21, 32'h05, 32'h23, 32'h20, 32'h61, 32'h05, 32'h23, 32'h2C, 32'h81, 32'h04,
        32'h23, 32'h2E, 32'h71, 32'h03, 32'h23, 32'h28, 32'hA1, 32'h03, 32'h23, 32'h26, 32'hB1, 32'h03, 32'h13, 32'h09, 32'h05, 32'h00,
        32'h13, 32'h1A, 32'h8A, 32'h00, 32'hB3, 32'h89, 32'h99, 32'h41, 32'h23, 32'h26, 32'hF1, 32'h00, 32'hB3, 32'h04, 32'h9C, 32'h00,
        32'h13, 32'h0B, 32'hF0, 32'h4F, 32'h83, 32'h27, 32'hC1, 32'h00, 32'h03, 32'h27, 32'h01, 32'h01, 32'h63, 32'hC8, 32'hE7, 32'h06,
        32'h93, 32'h85, 32'h09, 32'h00, 32'h13, 32'h85, 32'h09, 32'h00, 32'hEF, 32'h00, 32'h40, 32'h10, 32'h03, 32'h27, 32'h81, 32'h01,
        32'h93, 32'h17, 32'h2A, 32'h00, 32'h13, 32'h04, 32'h05, 32'h00, 32'h33, 32'h0D, 32'h80, 32'h41, 32'hB3, 32'h0D, 32'hF7, 32'h00,
        32'hB3, 32'h8B, 32'h99, 32'h01, 32'h6F, 32'h00, 32'h00, 32'h01, 32'h13, 32'h0D, 32'h1D, 32'h00, 32'h93, 32'h8D, 32'h4D, 32'h00,
        32'h63, 32'h0E, 32'h9D, 32'h02, 32'h93, 32'h05, 32'h0D, 32'h00, 32'h13, 32'h05, 32'h0D, 32'h00, 32'hEF, 32'h00, 32'h00, 32'h0D,
        32'h33, 32'h05, 32'h85, 32'h00, 32'hE3, 32'h42, 32'hA9, 32'hFE, 32'h33, 32'h07, 32'h5D, 32'h01, 32'hE3, 32'h6E, 32'hEB, 32'hFC,
        32'h93, 32'h07, 32'hF0, 32'h2C, 32'hE3, 32'hEA, 32'h77, 32'hFD, 32'h83, 32'h27, 32'hC1, 32'h01, 32'h13, 32'h0D, 32'h1D, 32'h00,
        32'h93, 32'h8D, 32'h4D, 32'h00, 32'h23, 32'hAE, 32'hFD, 32'hFE, 32'hE3, 32'h16, 32'h9D, 32'hFC, 32'h83, 32'h27, 32'h41, 32'h01,
        32'h93, 32'h89, 32'h19, 32'h00, 32'h13, 32'h0A, 32'h0A, 32'h50, 32'hE3, 32'h9E, 32'hF9, 32'hF6, 32'h03, 32'h24, 32'h81, 32'h05,
        32'h83, 32'h24, 32'h41, 32'h05, 32'h03, 32'h29, 32'h01, 32'h05, 32'h03, 32'h2A, 32'h81, 32'h04, 32'h03, 32'h2B, 32'h01, 32'h04,
        32'h83, 32'h2B, 32'hC1, 32'h03, 32'h03, 32'h2D, 32'h01, 32'h03, 32'h83, 32'h2D, 32'hC1, 32'h02, 32'h83, 32'h20, 32'hC1, 32'h05,
        32'h83, 32'h29, 32'hC1, 32'h04, 32'h83, 32'h2A, 32'h41, 32'h04, 32'h03, 32'h2C, 32'h81, 32'h03, 32'h83, 32'h2C, 32'h41, 32'h03,
        32'h13, 32'h01, 32'h01, 32'h06, 32'h67, 32'h80, 32'h00, 32'h00, 32'h13, 32'h01, 32'h01, 32'hFF, 32'h13, 32'h05, 32'hF0, 32'h0F,
        32'h23, 32'h26, 32'h11, 32'h00, 32'hEF, 32'hF0, 32'h5F, 32'hE4, 32'hB7, 32'h06, 32'hFF, 32'h00, 32'h13, 32'h06, 32'h00, 32'h05,
        32'h93, 32'h05, 32'h80, 32'h16, 32'h13, 32'h05, 32'h00, 32'h14, 32'hEF, 32'hF0, 32'h1F, 32'hE7, 32'hB7, 32'h06, 32'h01, 32'h00,
        32'h93, 32'h86, 32'h06, 32'hF0, 32'h13, 32'h06, 32'h00, 32'h05, 32'h93, 32'h05, 32'h80, 32'h16, 32'h13, 32'h05, 32'h00, 32'h28,
        32'hEF, 32'hF0, 32'h9F, 32'hE5, 32'h93, 32'h06, 32'hF0, 32'h0F, 32'h13, 32'h06, 32'h00, 32'h05, 32'h93, 32'h05, 32'h80, 32'h16,
        32'h13, 32'h05, 32'h00, 32'h3C, 32'hEF, 32'hF0, 32'h5F, 32'hE4, 32'h6F, 32'h00, 32'h00, 32'h00, 32'h13, 32'h06, 32'h05, 32'h00,
        32'h13, 32'h05, 32'h00, 32'h00, 32'h93, 32'hF6, 32'h15, 32'h00, 32'h63, 32'h84, 32'h06, 32'h00, 32'h33, 32'h05, 32'hC5, 32'h00,
        32'h93, 32'hD5, 32'h15, 32'h00, 32'h13, 32'h16, 32'h16, 32'h00, 32'hE3, 32'h96, 32'h05, 32'hFE, 32'h67, 32'h80, 32'h00, 32'h00
    };

    logic [31:0] test_prog[] = '{
        32'h00400293,
        32'h0002a303,
        32'h0fc00537,
        32'h00652223,
        32'h0000006f
    };

    // Task to send 1 byte over UART (8N1)
    task send_uart_byte(input logic [7:0] tx_byte);
        integer i;
        begin
            // Start Bit (LOW)
            uart_txd_in = 1'b0;
            #BIT_PERIOD;
            
            // 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                uart_txd_in = tx_byte[i];
                #BIT_PERIOD;
            end
            
            // Stop Bit (HIGH)
            uart_txd_in = 1'b1;
            #BIT_PERIOD;
        end
    endtask

    // Task to construct and transmit a 9-byte packet matching Python create_packet
    task send_packet(input logic [23:0] addr, input logic [31:0] data);
        // logic [7:0] addr_h, addr_m, addr_l;
        // logic [7:0] data_3, data_2, data_1, data_0;
        // logic [7:0] checksum;
        begin
            // addr_h = addr[23:16];
            // addr_m = addr[15:8];
            // addr_l = addr[7:0];
            
            // data_3 = data[31:24];
            // data_2 = data[23:16];
            // data_1 = data[15:8];
            // data_0 = data[7:0];
            
            // checksum = addr_h ^ addr_m ^ addr_l ^ data_3 ^ data_2 ^ data_1 ^ data_0;

            // // 9-byte packet sequence
            // send_uart_byte(8'hAB);
            // send_uart_byte(addr_h);
            // send_uart_byte(addr_m);
            // send_uart_byte(addr_l);
            // send_uart_byte(data_3);
            // send_uart_byte(data_2);
            // send_uart_byte(data_1);
            // send_uart_byte(data_0);
            // send_uart_byte(checksum);
            @(posedge CLK100MHZ);
            start_valid = HIGH;
            start_write_en = HIGH;
            start_data = data;
            start_addr = {6'b0, addr, 2'b0};
            @(posedge CLK100MHZ);
            @(posedge CLK100MHZ);
            start_valid = LOW;
            start_write_en = LOW;
        end
    endtask

    // Main Test Stimulus
    integer i;
    logic [23:0] current_address;
    logic [31:0] word_val;
    logic [7:0]  b0, b1, b2, b3;

    initial begin
        // Initial setup
        CLK100MHZ    = 0;
        ck_rst       = 0;
        uart_txd_in  = 1; // Idle state for UART is HIGH
        start_done = LOW;
        boot_start = LOW;
        start_valid = LOW;
        start_write_en = LOW;
        start_finish = LOW;
        start_data = '0;
        start_addr = '0;
        start_button = HIGH;
        reset_button = HIGH;
        
        // Reset sequence
        #100;
        reset_button = LOW; // De-assert reset

        #1000;
        ck_rst = 1;

        // Wait for boot_start (led[0]) to go HIGH
        $display("[%0t ns] Waiting for boot_start (led[0])...", $time);
        wait(mig_ready == 1'b1);
        $display("[%0t ns] boot_start detected HIGH!", $time);

        boot_start = HIGH;
        
        // Wait a few clock cycles
        repeat (10) @(posedge CLK100MHZ);

        current_address = 24'h000000;

        // Process test_prog array 4 bytes at a time (little-endian conversion)
        $display("[%0t ns] Loading Program", $time);
        // Process test_bytes array 4 bytes at a time (little-endian conversion)
        for (i = 0; i < $size(test_bytes); i = i + 4) begin
            b0 = test_bytes[i];
            b1 = (i + 1 < $size(test_bytes)) ? test_bytes[i+1] : 8'h00;
            b2 = (i + 2 < $size(test_bytes)) ? test_bytes[i+2] : 8'h00;
            b3 = (i + 3 < $size(test_bytes)) ? test_bytes[i+3] : 8'h00;

            // Little-endian assembly: {b3, b2, b1, b0}
            word_val = {b3, b2, b1, b0};

            send_packet(current_address, word_val);
            current_address = current_address + 1'b1;
            @(posedge start_bvalid);
            @(posedge CLK100MHZ);
        end

        // for (i = 0; i < $size(test_prog); i = i + 1) begin
        //     send_packet(current_address, test_prog[i]);
        //     current_address = current_address + 1'b1;
        //     @(posedge start_bvalid);
        //     @(posedge CLK100MHZ);
        // end

        // Send 5 "jal ." trailing packets (0x0000006F)
        $display("[%0t ns] Sending 2 trailing jal . packets...", $time);
        repeat (2) begin
            send_packet(current_address, 32'h0000006F);
            current_address = current_address + 1'b1;
        end

        start_finish = HIGH;

        // // Send finish byte (0xEF)
        // $display("[%0t ns] Transmitting finish byte (0xEF)...", $time);
        // send_uart_byte(8'hEF);

        // // Wait for start_finish (led[2]) to go HIGH
        // $display("[%0t ns] Waiting for start_finish (led[2])...", $time);
        // wait(led[2] == 1'b1);
        // $display("[%0t ns] start_finish detected HIGH!", $time);

        // Wait a few clock cycles before pressing start_button
        repeat (40) @(posedge CLK100MHZ);
        
        $display("[%0t ns] Pressing start_button...", $time);
        start_button = 1'b1;
        @(posedge CLK100MHZ);
        start_done = HIGH;
        start_finish = HIGH;
        boot_start = LOW;
        repeat (10) @(posedge CLK100MHZ);
        start_button = 1'b0;


        // Allow time for the loaded program to execute
        $display("[%0t ns] Program started, running simulation...", $time);
        #2000000; // Adjust simulation duration as necessary

        $display("[%0t ns] Testbench complete.", $time);
        $finish;
    end

endmodule