package ctrl_signal_pkg;
    typedef struct packed {
        logic[4:0] MUX_en;
        logic[3:0] ALU_op;
        logic mem_write;
        logic mem_read;
        logic write_back;
        logic [1:0] mem_bytes;
        logic mem_zero_extend;
        logic predicted_jump;
    } ctrl_signal_t;

    typedef enum logic[3:0] { 
        RS1_DEF_RS2_DEF  = 4'd0,
        RS1_DEF_RS2_EX   = 4'd1,
        RS1_DEF_RS2_MEM  = 4'd2,
        RS1_EX_RS2_DEF   = 4'd3,
        RS1_EX_RS2_EX    = 4'd4,
        RS1_EX_RS2_MEM   = 4'd5,
        RS1_MEM_RS2_DEF  = 4'd6,
        RS1_MEM_RS2_EX   = 4'd7,
        RS1_MEM_RS2_MEM  = 4'd8
    } forwarding_setting_t;
endpackage