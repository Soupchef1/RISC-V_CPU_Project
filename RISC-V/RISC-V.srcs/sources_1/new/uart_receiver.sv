`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2026 08:06:49 PM
// Design Name: 
// Module Name: uart_receiver
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


module uart_receiver(
        input logic clk, nrst,
        input logic rx,
        output logic rx_valid,
        output logic [7:0] rx_data
    );

    localparam logic [5:0] CLKS_PER_BIT = 6'd49; // 100 MHz clock / 2,000,000 baud rate - 1
    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } uart_state; 

    uart_state state, next_state;

    logic [5:0] clk_cnt, next_clk_cnt;
    logic [2:0] bit_cnt, next_bit_cnt;
    logic [7:0] data, next_data;
    logic valid, next_valid;

    logic rx_sync, rx_sync_m; //registers for stable and unstable rx values

    assign rx_ready = valid;
    assign rx_data = data;

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            rx_sync_m <= HIGH;
            rx_sync <= HIGH;
        end else begin
            rx_sync_m <= rx;
            rx_sync <= rx_sync_m;
        end
    end

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            state <= IDLE;
            clk_cnt <= '0;
            bit_cnt <= '0;
            data <= '0;
            valid <= LOW;
        end else begin
            state <= next_state;
            clk_cnt <= next_clk_cnt;
            bit_cnt <= next_bit_cnt;
            data <= next_data;
            valid <= next_valid;
        end
    end

    always_comb begin
        case(state)
            IDLE: begin
                next_state = (rx_sync == LOW) ? START : IDLE;
                next_clk_cnt = '0;
                next_bit_cnt = '0;
                next_data = data;
                next_valid = LOW;
            end

            START: begin
                if (clk_cnt == 6'd24) begin //sample at middle of rx signal to ensure validity, rest of states also sample at middle of rx signal now
                    if(rx_sync == LOW) begin // valid start
                        next_clk_cnt = '0;
                        next_state = DATA;
                    end else begin //invalid start (ie. random noise pulled start low for a bit)
                        next_clk_cnt = '0;
                        next_state = IDLE; 
                    end
                end else begin
                    next_clk_cnt = clk_cnt + 5'd1;
                    next_state = START;
                end

                next_bit_cnt = '0;
                next_data = data;
                next_valid = LOW;
            end

            DATA: begin
                if(clk_cnt == CLKS_PER_BIT) begin
                    next_clk_cnt = '0;
                    next_data = {rx_sync, data[7:1]}; //make new data msb and bit shift rest right
                    
                    if(bit_cnt == 3'd7) begin
                        next_state = STOP;
                        next_bit_cnt = '0;
                    end else begin
                        next_state = DATA;
                        next_bit_cnt = bit_cnt + 3'd1;
                    end
                end else begin
                    next_state = DATA;
                    next_clk_cnt = clk_cnt + 6'd1;
                    next_data = data;
                    next_bit_cnt = bit_cnt;
                end

                next_valid = LOW;
            end

            STOP: begin
                if(clk_cnt == CLKS_PER_BIT) begin
                    next_state = IDLE;
                    next_clk_cnt = '0;
                    next_valid = rx_sync;
                end else begin
                    next_state = STOP;
                    next_clk_cnt = clk_cnt + 6'd1;
                    next_valid = LOW;
                end

                next_bit_cnt = '0;
                next_data = data;
            end

            default: begin
                next_state = IDLE;
                next_clk_cnt = '0;
                next_bit_cnt = '0;
                next_data = data;
                valid = LOW;
            end
        endcase
    end
endmodule
