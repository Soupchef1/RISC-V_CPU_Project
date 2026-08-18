`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Trip Taylor - CEO/Co-Founder
// 
// Create Date: 06/28/2026 08:49:26 PM
// Design Name: 
// Module Name: forwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Needs testbench 
// 
//////////////////////////////////////////////////////////////////////////////////



// DEF = use value from register file
// EX = forward result from execute stage
// MEM = forward result from memory stage

// module forwardingUnit(
//     input logic [4:0] rs1_decode, //rd1
//     input logic [4:0] rs2_decode, //rd2
//     input logic [4:0] rd_ex,
//     input logic [4:0] rd_mem,


//     output forwarding_setting_t FUmux
//     );

//     always_comb begin 
//         // forwarding logic
//         FUmux = RS1_DEF_RS2_DEF; //default case

//         // checking for matching register addresses
//         if(rs1_decode == rd_ex && rd_ex != 0) begin
//             if(rs2_decode == rd_ex && rd_ex != 0)begin
//                 FUmux = RS1_EX_RS2_EX;
//             end
//             else if(rs2_decode == rd_mem && rd_mem != 0)begin
//                 FUmux = RS1_EX_RS2_MEM;
//             end
//             else begin 
//                 FUmux = RS1_EX_RS2_DEF;
//             end
//         end
//         else if(rs1_decode == rd_mem && rd_mem != 0) begin
//             if(rs2_decode == rd_ex && rd_ex != 0)begin
//                 FUmux = RS1_MEM_RS2_EX;
//             end
//             else if(rs2_decode == rd_mem && rd_mem != 0 )begin
//                 FUmux = RS1_MEM_RS2_MEM;
//             end
//             else begin 
//                 FUmux = RS1_MEM_RS2_DEF;
//             end
//         end
//         else begin
//             if(rs2_decode == rd_ex && rd_ex != 0)begin
//                 FUmux = RS1_DEF_RS2_EX;
//             end
//             else if(rs2_decode == rd_mem && rd_mem != 0)begin
//                 FUmux = RS1_DEF_RS2_MEM;
//             end
//             else begin 
//                 FUmux = RS1_DEF_RS2_DEF;
//             end
//         end
//     end
// endmodule

module forwardingUnit(
        input logic clk, nrst,
        input logic [4:0] rs1_addr, rs2_addr,
        input logic [31:0] rs1_data, rs2_data,
        (* max_fanout = 20 *) input logic [4:0] MA_rd, WB_rd,
        input logic [31:0] WB_data,
        input logic MA_write_back, WB_write_back, 
        input logic stall,

        output logic [31:0] rs1, rs2,
        output logic FU_stall
    );

    (* max_fanout = 20 *) logic [31:0] WB2_data; //WB2 represents pipeline reg after WB stage. Needed in case both WB and MA have values that need to be forwarded
    (* max_fanout = 20 *) logic [4:0] WB2_rd;
    (* max_fanout = 20 *) logic WB2_write_back;

    assign FU_stall = (MA_rd != 5'b0) & ((rs2_addr == MA_rd) || (rs1_addr == MA_rd)) & MA_write_back;

    always_comb begin
        rs1 = rs1_data;
        if(rs1_addr != 5'b0) begin
            if ((rs1_addr == WB_rd) & WB_write_back) begin
                rs1 = WB_data;
            end else if ((rs1_addr == WB2_rd) & WB2_write_back) begin
                rs1 = WB2_data;
            end
        end
    end

    always_comb begin
        rs2 = rs2_data;
        if(rs2_addr != 5'b0) begin
            if ((rs2_addr == WB_rd) & WB_write_back) begin
                rs2 = WB_data;
            end else if ((rs2_addr == WB2_rd) & WB2_write_back) begin
                rs2 = WB2_data;
            end
        end
    end

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            WB2_data <= '0;
            WB2_rd <= '0;
            WB2_write_back <= '0;
        end else begin
            if(!stall) begin
                WB2_data <= WB_data;
                WB2_rd <= WB_rd;
                WB2_write_back <= WB_write_back;
            end
        end
    end

endmodule
