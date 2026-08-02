`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2026 10:51:36 PM
// Design Name: 
// Module Name: vdma_controller
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

// Axi-lite protocol: https://www.realdigital.org/doc/a9fee931f7a172423e1ba73f66ca4081
import axi_lite_pkg::*;

module vdma_controller(
    // AXI-Lite
    input axi_write_in_t axi_write_in,
    output axi_write_out_t axi_write_out,

    // General
    input logic clk,
    input logic nrst,
    input logic buffer_change
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    // State definitions ------------
    typedef enum logic[1:0] { 
        AXI_IDLE,
        AXI_WRITE_ADDR_DATA,
        AXI_WAIT_RESPONSE,
        AXI_CHECK_RESPONSE
     } axi_state_t;

    axi_state_t axi_state;
    logic addr_sent;
    logic data_sent;

    // main FSM -> AXI
    logic write_start;
    logic[31:0] write_address;
    logic[31:0] write_data;

    // AXI -> main FSM
    logic write_busy;
    logic write_done;
    logic write_error;
    logic[31:0] current_addr;
    logic[31:0] current_data;

    typedef enum logic[1:0] { 
        STARTUP,
        IDLE,
        CHANGING_FRAME
    } controller_state_t;

    controller_state_t controller_state;

    // VDMA utility and register addresses --------
    typedef struct packed {
        logic[31:0] control_value;
        logic[31:0] park_ptr;
        logic[31:0] start_addr1;
        logic[31:0] start_addr2;
        logic[31:0] delay_stride;
        logic[31:0] frame_width;
        logic[31:0] frame_height;
    } vdma_config_t;

    vdma_config_t vdma_config;

    typedef enum logic[2:0] { 
        SEND_CONTROL_VALUE,
        SEND_PARK_PTR,
        SEND_START_ADDR1,
        SEND_START_ADDR2,
        SEND_DELAY_STRIDE,
        SEND_FRAME_WIDTH,
        SEND_FRAME_HEIGHT
    } vdma_axi_startup_index_t;

    vdma_axi_startup_index_t startup_index;

    // 1280x720
    localparam logic[31:0] SCREEN_WIDTH         = 32'd40960; // 1280*WORD_LENGTH
    localparam logic[31:0] SCREEN_HEIGHT        = 32'd720;
    localparam logic[31:0] DEF_DELAY_STRIDE     = 32'd40960;
    localparam logic[31:0] VDMA_ON              = 32'b1;

    localparam logic[31:0] CONTROL_VALUE_ADDR   = 32'h0000_0000;
    localparam logic[31:0] PARK_PTR_ADDR        = 32'h0000_0028;
    localparam logic[31:0] START_ADDR1_ADDR     = 32'h0000_005C;
    localparam logic[31:0] START_ADDR2_ADDR     = 32'h0000_0060;
    localparam logic[31:0] DELAY_STRIDE_ADDR    = 32'h0000_0058;
    localparam logic[31:0] FRAME_WIDTH_ADDR     = 32'h0000_0054;
    localparam logic[31:0] FRAME_HEIGHT_ADDR    = 32'h0000_0050;

    localparam vdma_config_t DEFAULT_CONFIG = '{
        control_value : VDMA_ON,
        park_ptr : '0,
        start_addr1 : START_ADDR1_ADDR,
        start_addr2 : START_ADDR2_ADDR,
        delay_stride : DEF_DELAY_STRIDE,
        frame_width : SCREEN_WIDTH,
        frame_height : SCREEN_HEIGHT,
        };

    //VDMA Controller FSM---------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            controller_state <= STARTUP;
            startup_index <= SEND_CONTROL_VALUE;
            vdma_config <= DEFAULT_CONFIG;
        end

        else begin
            case(controller_state) 
                STARTUP: begin

                    case(startup_index)
                        SEND_CONTROL_VALUE: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_PARK_PTR;
                            end
                        end

                        SEND_PARK_PTR: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_START_ADDR1;
                            end
                        end

                        SEND_START_ADDR1: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_START_ADDR2;
                            end
                        end

                        SEND_START_ADDR2: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_DELAY_STRIDE;
                            end
                        end

                        SEND_DELAY_STRIDE: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_FRAME_WIDTH;
                            end
                        end

                        SEND_FRAME_WIDTH: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_FRAME_HEIGHT;
                            end
                        end

                        SEND_FRAME_HEIGHT: begin
                            if(write_done == HIGH) begin
                                controller_state <= IDLE; //END OF CONFIG STARTUP
                            end
                        end

                        default: begin
                        end
                    endcase

                end

                IDLE: begin
                    if(buffer_change == HIGH) begin
                        controller_state <= CHANGING_FRAME;
                    end
                end

                CHANGING_FRAME: begin
                    if(write_done == HIGH) begin
                        if(write_error == HIGH) begin
                            controller_state <= STARTUP; //reset on bad write
                        end
                        else begin
                            controller_state <= IDLE;
                            vdma_config.park_ptr[0] <= ~vdma_config.park_ptr[0]; //Toggle LSB
                        end
                    end
                end

                default: begin
                end
            endcase
        end
    end

    always_comb begin
        // Default singals
        write_address = '0;
        write_data = '0;
        write_start = LOW;

        case(controller_state)
            STARTUP: begin
                case(startup_index)
                    SEND_CONTROL_VALUE: begin
                        if(!write_busy) begin
                            write_address = CONTROL_VALUE_ADDR;
                            write_data = DEFAULT_CONFIG.control_value;
                            write_start = HIGH;
                        end
                    end

                    SEND_PARK_PTR: begin
                        if(!write_busy) begin
                            write_address = PARK_PTR_ADDR;
                            write_data = DEFAULT_CONFIG.park_ptr;
                            write_start = HIGH;
                        end
                    end

                    SEND_START_ADDR1: begin
                        if(!write_busy) begin
                            write_address = START_ADDR1_ADDR;
                            write_data = DEFAULT_CONFIG.start_addr1;
                            write_start = HIGH;
                        end
                    end

                    SEND_START_ADDR2: begin
                        if(!write_busy) begin
                            write_address = START_ADDR2_ADDR;
                            write_data = DEFAULT_CONFIG.start_addr2;
                            write_start = HIGH;
                        end
                    end

                    SEND_DELAY_STRIDE: begin
                        if(!write_busy) begin
                            write_address = DELAY_STRIDE_ADDR;
                            write_data = DEFAULT_CONFIG.delay_stride;
                            write_start = HIGH;
                        end
                    end

                    SEND_FRAME_WIDTH: begin
                        if(!write_busy) begin
                            write_address = FRAME_WIDTH_ADDR;
                            write_data = DEFAULT_CONFIG.frame_width;
                            write_start = HIGH;
                        end
                    end

                    SEND_FRAME_HEIGHT: begin
                        if(!write_busy) begin
                            write_address = FRAME_HEIGHT_ADDR;
                            write_data = DEFAULT_CONFIG.frame_height;
                            write_start = HIGH;
                        end
                    end

                    default: begin
                    end
                endcase
            end

            IDLE: begin
            end

            CHANGING_FRAME: begin
                if(!write_busy) begin
                    write_address = PARK_PTR_ADDR;
                    write_data = vdma_config.park_ptr; 
                    write_start = HIGH;
                end
            end

            default: begin
            end
        endcase
    end

    //AXI-TRANSACTION FSM---------------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            axi_state <= AXI_IDLE;
            addr_sent <= LOW;
            data_sent <= LOW;
            write_busy <= LOW;
            write_done <= LOW;
            write_error <= LOW;
        end

        else begin
            case(axi_state)

                AXI_IDLE: begin
                    // default values for handshake
                    write_done <= LOW;
                    write_error <= LOW;
                    addr_sent <= LOW;
                    data_sent <= LOW;

                    if(write_start == HIGH)begin
                        current_addr <= write_address;
                        current_data <= write_data;
                        write_busy <= HIGH;
                        axi_state <= AXI_WRITE_ADDR_DATA;
                    end
                end

                AXI_WRITE_ADDR_DATA: begin
                if(axi_write_out.awvalid == HIGH && axi_write_in.awready == HIGH) begin
                    addr_sent <= HIGH;
                end

                if(axi_write_out.wvalid == HIGH && axi_write_in.wready == HIGH) begin
                    data_sent <= HIGH;
                end

                    if(addr_sent == HIGH && data_sent == HIGH) begin
                        axi_state <= AXI_WAIT_RESPONSE;
                    end
                end


                AXI_WAIT_RESPONSE: begin
                    if(axi_write_in.bvalid) begin
                        axi_state <= AXI_CHECK_RESPONSE;
                    end
                end

                AXI_CHECK_RESPONSE: begin
                    if(axi_write_in.bresp != AXI_OKAY) begin
                        write_busy <= LOW;
                        write_done <= HIGH;
                        write_error <= HIGH;
                        axi_state <= AXI_IDLE;  //reset on bad write
                    end

                    else begin
                        write_done <= HIGH; 
                        axi_state <= AXI_IDLE;
                        write_busy <= LOW;
                    end
                end

                default: begin
                end
            endcase
        end
    end

    // AXI-TRANSACTION SIGNAL LOGIC ---------------------------------------------------------------------
    always_comb begin
        // default signal assignments
        axi_write_out.awaddr = '0;
        axi_write_out.awvalid = LOW;
        axi_write_out.wdata = '0;
        axi_write_out.wvalid = LOW;

        case(axi_state) 

            AXI_IDLE: begin
                axi_write_out.bready = LOW;
            end

            AXI_WRITE_ADDR_DATA: begin
                axi_write_out.awaddr = current_addr;
                axi_write_out.awvalid = HIGH;
                axi_write_out.wdata = current_data;
                axi_write_out.wvalid = HIGH;
                axi_write_out.bready = LOW;

            end

            AXI_WAIT_RESPONSE: begin
                axi_write_out.bready = HIGH;
            end

            AXI_CHECK_RESPONSE: begin
            end

            default: begin
            end
        endcase
    end
endmodule
