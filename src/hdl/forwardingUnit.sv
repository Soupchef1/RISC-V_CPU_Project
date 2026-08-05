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
        input logic [4:0] rs1_addr, rs2_addr,
        input logic [31:0] rs1_data, rs2_data,
        input logic [4:0] MA_rd, WB_rd,
        input logic [31:0] WB_data,
        input logic MA_write_back, WB_write_back, 

        output logic [31:0] rs1, rs2,
        output logic FU_stall
    );

    assign FU_stall = ((rs2_addr || rs1_addr) == MA_rd) & MA_write_back;

    always_comb begin
        if ((rs1_addr == WB_rd) & WB_write_back) begin
            rs1 = WB_data;
        end else begin
            rs1 = rs1_data;
        end
    end

    always_comb begin
        if ((rs2_addr == WB_rd) & WB_write_back) begin
            rs2 = WB_data;
        end else begin
            rs2 = rs2_data;
        end
    end

endmodule