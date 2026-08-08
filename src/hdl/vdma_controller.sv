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
    input logic buffer_change,
    input logic startup_done
    );

    localparam logic HIGH = 1'b1;
    localparam logic LOW = 1'b0;

    // State definitions ------------
    typedef enum logic[1:0] { 
        AXI_IDLE,
        AXI_WRITE_ADDR,
        AXI_WRITE_DATA,
        AXI_WAIT_RESPONSE
     } axi_state_t;

    axi_state_t axi_state, next_axi_state;

    // main FSM -> AXI
    logic write_start;
    logic[8:0] write_address;
    logic[31:0] write_data;

    // AXI -> main FSM
    logic write_busy;
    logic write_done;
    logic write_error;

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

    logic park_ptr;

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
    localparam logic [31:0] VBUFFER_1           = 32'h0FC0_0000;
    localparam logic [31:0] VBUFFER_2           = 32'h0F80_0000;

    localparam logic[8:0] CONTROL_VALUE_ADDR   = 9'h00;
    localparam logic[8:0] PARK_PTR_ADDR        = 9'h28;
    localparam logic[8:0] START_ADDR1_ADDR     = 9'h5C;
    localparam logic[8:0] START_ADDR2_ADDR     = 9'h60;
    localparam logic[8:0] DELAY_STRIDE_ADDR    = 9'h58;
    localparam logic[8:0] FRAME_WIDTH_ADDR     = 9'h54;
    localparam logic[8:0] FRAME_HEIGHT_ADDR    = 9'h50;

    localparam vdma_config_t DEFAULT_CONFIG = '{
        control_value : VDMA_ON,
        park_ptr : '0,
        start_addr1 : VBUFFER_1,
        start_addr2 : VBUFFER_2,
        delay_stride : DEF_DELAY_STRIDE,
        frame_width : SCREEN_WIDTH,
        frame_height : SCREEN_HEIGHT
        };

    //VDMA Controller FSM---------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            controller_state <= STARTUP;
            startup_index <= SEND_CONTROL_VALUE;
            park_ptr <= LOW;
            write_start <= HIGH;
        end

        else begin
            case(controller_state) 
                STARTUP: begin
                    case(startup_index)
                        SEND_CONTROL_VALUE: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_PARK_PTR;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_PARK_PTR: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_START_ADDR1;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_START_ADDR1: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_START_ADDR2;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_START_ADDR2: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_DELAY_STRIDE;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_DELAY_STRIDE: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_FRAME_WIDTH;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_FRAME_WIDTH: begin
                            if(write_done == HIGH) begin
                                startup_index <= SEND_FRAME_HEIGHT;
                                write_start <= HIGH;
                            end else begin
                                write_start <= LOW;
                            end
                        end

                        SEND_FRAME_HEIGHT: begin
                            write_start <= LOW;

                            if(write_done == HIGH && startup_done == HIGH) begin
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
                        write_start <= HIGH;
                        park_ptr <= ~park_ptr; //Toggle park_ptr
                    end else begin
                        write_start <= LOW;
                    end
                end

                CHANGING_FRAME: begin
                    if(write_done == HIGH) begin
                        if(write_error == HIGH) begin
                            controller_state <= CHANGING_FRAME; //rewrite on bad write
                            write_start <= HIGH;
                        end
                        else begin
                            controller_state <= IDLE;
                        end
                    end else begin
                        write_start <= LOW;
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

        case(controller_state)
            STARTUP: begin
                case(startup_index)
                    SEND_CONTROL_VALUE: begin
                        write_address = CONTROL_VALUE_ADDR;
                        write_data = DEFAULT_CONFIG.control_value;
                    end

                    SEND_PARK_PTR: begin
                        write_address = PARK_PTR_ADDR;
                        write_data = DEFAULT_CONFIG.park_ptr;
                    end

                    SEND_START_ADDR1: begin
                        write_address = START_ADDR1_ADDR;
                        write_data = DEFAULT_CONFIG.start_addr1;
                    end

                    SEND_START_ADDR2: begin
                        write_address = START_ADDR2_ADDR;
                        write_data = DEFAULT_CONFIG.start_addr2;
                    end

                    SEND_DELAY_STRIDE: begin
                        write_address = DELAY_STRIDE_ADDR;
                        write_data = DEFAULT_CONFIG.delay_stride;
                    end

                    SEND_FRAME_WIDTH: begin
                        write_address = FRAME_WIDTH_ADDR;
                        write_data = DEFAULT_CONFIG.frame_width;
                    end

                    SEND_FRAME_HEIGHT: begin
                        write_address = FRAME_HEIGHT_ADDR;
                        write_data = DEFAULT_CONFIG.frame_height;
                    end

                    default: begin
                    end
                endcase
            end

            IDLE: begin
            end

            CHANGING_FRAME: begin
                write_address = PARK_PTR_ADDR;
                write_data = {31'b0, park_ptr};
            end

            default: begin
            end
        endcase
    end

    //AXI-TRANSACTION FSM---------------------------------------------------------------------

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            axi_state <= AXI_IDLE;
            write_error <= LOW;
        end

        else begin
            axi_state <= next_axi_state;
            if(axi_state == AXI_WAIT_RESPONSE && axi_write_in.bvalid == HIGH && axi_write_in.bresp != AXI_OKAY) begin
                write_error <= HIGH;
            end
        end
    end

    // AXI-TRANSACTION SIGNAL LOGIC ---------------------------------------------------------------------
    always_comb begin
        next_axi_state = axi_state;

        // default signal assignments
        axi_write_out.awaddr = '0;
        axi_write_out.awvalid = LOW;
        axi_write_out.wdata = '0;
        axi_write_out.wvalid = LOW;
        axi_write_out.bready  = LOW;
        write_done = LOW;

        case(axi_state) 

            AXI_IDLE: begin
                if(write_start) begin
                    next_axi_state = AXI_WRITE_ADDR;
                end
                write_done = HIGH;
            end

            AXI_WRITE_ADDR: begin
                next_axi_state = (axi_write_in.awready == HIGH) ? AXI_WRITE_DATA : AXI_WRITE_ADDR;
                axi_write_out.awaddr = write_address;
                axi_write_out.wdata = write_data;
                axi_write_out.awvalid = HIGH;
            end

            AXI_WRITE_DATA: begin
                next_axi_state = (axi_write_in.wready == HIGH) ? AXI_WAIT_RESPONSE : AXI_WRITE_DATA;
                axi_write_out.awaddr = write_address;
                axi_write_out.wdata = write_data;
                axi_write_out.wvalid = HIGH;
            end

            AXI_WAIT_RESPONSE: begin
                if(axi_write_in.bvalid == HIGH) begin
                    next_axi_state = AXI_IDLE;
                    write_done = HIGH;
                end else begin
                    next_axi_state = AXI_WAIT_RESPONSE;
                end

                axi_write_out.awaddr = write_address;
                axi_write_out.wdata = write_data;
                axi_write_out.bready = HIGH;
            end

            default: begin
            end
        endcase
    end
endmodule
