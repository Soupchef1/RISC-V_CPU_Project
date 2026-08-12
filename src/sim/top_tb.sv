`timescale 1ns / 1ps

module tb_top;

    // Inputs
    logic CLK100MHZ;
    logic ck_rst;
    logic start_button;
    logic uart_txd_in;

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



    // Unit Under Test (UUT)
    top uut (
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
        .ddr3_sdram_odt(ddr3_sdram_odt)
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
        8'h93, 8'h02, 8'hA0, 8'h00, 8'h13, 8'h03, 8'h40, 8'h01, 8'hB3, 8'h83,
        8'h62, 8'h00, 8'h93, 8'h83, 8'h03, 8'h00, 8'h6F, 8'hF0, 8'hDF, 8'hFF
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
        logic [7:0] addr_h, addr_m, addr_l;
        logic [7:0] data_3, data_2, data_1, data_0;
        logic [7:0] checksum;
        begin
            addr_h = addr[23:16];
            addr_m = addr[15:8];
            addr_l = addr[7:0];
            
            data_3 = data[31:24];
            data_2 = data[23:16];
            data_1 = data[15:8];
            data_0 = data[7:0];
            
            checksum = addr_h ^ addr_m ^ addr_l ^ data_3 ^ data_2 ^ data_1 ^ data_0;

            // 9-byte packet sequence
            send_uart_byte(8'hAB);
            send_uart_byte(addr_h);
            send_uart_byte(addr_m);
            send_uart_byte(addr_l);
            send_uart_byte(data_3);
            send_uart_byte(data_2);
            send_uart_byte(data_1);
            send_uart_byte(data_0);
            send_uart_byte(checksum);
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
        start_button = 0;
        uart_txd_in  = 1; // Idle state for UART is HIGH
        
        // Reset sequence
        #100;
        ck_rst = 1; // De-assert reset
        
        // Wait for boot_start (led[0]) to go HIGH
        $display("[%0t ns] Waiting for boot_start (led[0])...", $time);
        wait(led[0] == 1'b1);
        $display("[%0t ns] boot_start detected HIGH!", $time);

        // Wait a few clock cycles
        repeat (10) @(posedge CLK100MHZ);

        current_address = 24'h000000;

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
        end

        // Send 5 "jal ." trailing packets (0x0000006F)
        $display("[%0t ns] Sending 5 trailing jal . packets...", $time);
        repeat (2) begin
            send_packet(current_address, 32'h0000006F);
            current_address = current_address + 1'b1;
        end

        // Send finish byte (0xEF)
        $display("[%0t ns] Transmitting finish byte (0xEF)...", $time);
        send_uart_byte(8'hEF);

        // Wait for start_finish (led[2]) to go HIGH
        $display("[%0t ns] Waiting for start_finish (led[2])...", $time);
        wait(led[2] == 1'b1);
        $display("[%0t ns] start_finish detected HIGH!", $time);

        // Wait a few clock cycles before pressing start_button
        repeat (20) @(posedge CLK100MHZ);
        
        $display("[%0t ns] Pressing start_button...", $time);
        start_button = 1'b1;
        repeat (10) @(posedge CLK100MHZ);
        start_button = 1'b0;

        // Allow time for the loaded program to execute
        $display("[%0t ns] Program started, running simulation...", $time);
        #50000; // Adjust simulation duration as necessary

        $display("[%0t ns] Testbench complete.", $time);
        $finish;
    end

endmodule