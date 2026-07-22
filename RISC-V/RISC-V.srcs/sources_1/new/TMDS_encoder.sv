`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2026 12:52:46 PM
// Design Name: 
// Module Name: TMDS_encoder
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


module TMDS_encoder (

    input logic pixel_clk,
    input logic nrst,

    input logic [7:0] color,
    input logic hsync,
    input logic vsync,
    input logic vid_active,

    output logic [9:0] tmds

    );

    logic [3:0] ones_cnt; //cnt for color data
    logic [3:0] zero_cnt;
    logic [3:0] ones_cnt_t; //cnt for tmds values
    logic [3:0] zero_cnt_t; 
    logic [8:0] q_m; //intermediate tmds data
    logic use_xnor; 
    logic [4:0] disparity;

    always_comb begin
        ones_cnt = '0;
        for (int i = 0; i < 8; i++) begin
            ones_cnt += color[i];
        end
        zero_cnt = 4'd8 - ones_cnt;
    

        use_xnor = ((ones_cnt > 4'd4) || ((ones_cnt == 4'd4) && (color[0] == 1'b0)));

        q_m[0] = color[0];
        if(use_xnor) begin
            for (int i = 1; i < 8; i++) begin
                q_m[i] = q_m[i-1] ~^ color[i];
            end
            q_m[8] = 1'b0;
        end
        else begin
            for (int i = 1; i < 8; i++) begin
                q_m[i] = q_m[i-1] ^ color[i];
            end
            q_m[8] = 1'b1;
        end

        ones_cnt_t = '0;
        for (int i = 0; i < 8; i++) begin
            ones_cnt_t += q_m[i];
        end
        zero_cnt_t = 4'd8 - ones_cnt_t;

    end

    always_ff @(posedge pixel_clk, negedge nrst) begin

        if(!nrst) begin
            disparity <= 5'sd0;
            tmds <= '0;
        end
        else if (!vid_active) begin
            disparity <= 5'sd0;
            case ({vsync, hsync}) 
                2'b00:   tmds <= 10'b1101010100;
                2'b01:   tmds <= 10'b0010101011;
                2'b10:   tmds <= 10'b0101010100;
                2'b11:   tmds <= 10'b1010101011;
                default: tmds <= 10'b1101010100;
            endcase
        end
        else begin
            if ((disparity == 5'sd0) || (ones_cnt_t == zero_cnt_t)) begin
                tmds[9] <= ~q_m[8];
                tmds[8] <= q_m[8];
                tmds[7:0] <= (q_m[8] ? q_m[7:0] : ~q_m[7:0]);
                disparity <= (q_m[8] ? (disparity + (ones_cnt_t - zero_cnt_t)) : (disparity + (zero_cnt_t - ones_cnt_t)));
            end
            else if (((disparity > 5'sd0) && (ones_cnt_t > zero_cnt_t)) || ((disparity < 5'sd0) && (zero_cnt_t > ones_cnt_t))) begin
                tmds[9] <= 1'b1;
                tmds[8] <= q_m[8];
                tmds[7:0] <=  ~q_m[7:0];
                disparity <= disparity + {q_m[8], 1'b0} + (zero_cnt_t - ones_cnt_t);
            end
            else begin
                tmds[9] <= 1'b0;
                tmds[8] <= q_m[8];
                tmds[7:0] <=  q_m[7:0];
                disparity <= disparity - {~q_m[8], 1'b0} + (ones_cnt_t - zero_cnt_t);
            end
        end
            
    end


endmodule
