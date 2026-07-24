`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2026 05:33:30 PM
// Design Name: 
// Module Name: uart_packet_reader
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


module uart_packet_reader(
        input logic clk, nrst,
        input logic rx_valid,
        input logic [7:0] rx_data,

        output logic [31:0] addr, data,
        output logic pkt_ready, pkt_failed, 
        output logic boot_finish
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;
    localparam logic [7:0] START = 8'hAB;
    localparam logic [7:0] FINISH = 8'hEF;

    typedef enum logic [3:0] {
        IDLE,
        ADDR_HIGH,
        ADDR_MID,
        ADDR_LOW,
        DATA_3,
        DATA_2,
        DATA_1,
        DATA_0,
        CHECKSUM
    } packet_state;

    packet_state state, next_state;
    
    logic [31:0] next_data, next_addr;
    logic [7:0] calculated_checksum, next_calculated_checksum;
    logic next_pkt_ready;

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= IDLE;
            addr <= '0;
            data <= '0;
            pkt_ready <= LOW;
            calculated_checksum <= '0;
        end else begin
            state <= next_state;
            addr <= next_addr;
            data <= next_addr;
            pkt_ready <= next_pkt_ready;
            calculated_checksum <= next_calculated_checksum;

            if(state == CHECKSUM && rx_valid &&calculated_checksum != rx_data) begin
                pkt_failed <= HIGH;
            end
        end
    end

    always_comb begin
        next_addr = addr;
        next_data = data;
        next_pkt_ready = LOW;
        next_calculated_checksum = calculated_checksum;
        boot_finish = LOW;

        if(rx_valid) begin
            casez(state)
                IDLE: begin
                    next_state = (rx_data == START) ? ADDR_HIGH : IDLE;
                    next_calculated_checksum = '0;
                    boot_finish = (rx_data == FINISH) ? HIGH : LOW;
                end

                ADDR_HIGH: begin
                    next_state = ADDR_MID;
                    next_addr[25:18] = rx_data;
                    next_calculated_checksum = rx_data;
                end

                ADDR_MID: begin
                    next_state = ADDR_LOW;
                    next_addr[17:10] = rx_data;
                    next_calculated_checksum = calculated_checksum ^ rx_data;
                end

                ADDR_LOW: begin
                    next_state = DATA_3;
                    next_addr[9:2] = rx_data;
                    next_calculated_checksum = calculated_checksum ^ rx_data;
                end

                DATA_3: begin
                    next_state = DATA_2;
                    next_data[31:24] = rx_data;  
                    next_calculated_checksum = calculated_checksum ^ rx_data;      
                end

                DATA_2: begin
                    next_state = DATA_1;
                    next_data[23:16] = rx_data;
                    next_calculated_checksum = calculated_checksum ^ rx_data;
                end

                DATA_1: begin
                    next_state = DATA_0;
                    next_data[15:8] = rx_data;
                    next_calculated_checksum = calculated_checksum ^ rx_data;
                end

                DATA_0: begin
                    next_state = CHECKSUM;
                    next_data[7:0] = rx_data;
                    next_calculated_checksum = calculated_checksum ^ rx_data;
                end

                CHECKSUM: begin
                    next_state = IDLE;
                    next_pkt_ready = HIGH;
                end

                default: begin
                    next_state = IDLE;
                    next_addr = addr;
                    next_data = data;
                    next_pkt_ready = LOW;
                    next_calculated_checksum = calculated_checksum;
                    boot_finish = LOW;
                end
            endcase
        end else begin
            next_state = state;
        end
    end
endmodule
