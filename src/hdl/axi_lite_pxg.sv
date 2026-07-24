package axi_lite_pkg;

    typedef enum logic[1:0] { 
        AXI_OKAY    = 2'b00,
        AXI_SLVERR  = 2'b10, //slave error
        AXI_DECERR = 2'b11  //decode error
    } bresp_t;

    typedef struct packed { //Master -> slave

        // write address
        logic[31:0] awaddr;
        logic awvalid;
        logic awprot[2:0];

        // write data
        logic[31:0] wdata;
        logic[3:0] wstrb;
        logic wvalid;

        // write response
        logic bready;
    } axi_write_out_t;

    typedef struct packed { //Slave -> master

        // write address
        logic awready;
        
        // write data
        logic wready;

        // write response
        bresp_t bresp; 
        logic bvalid;
    } axi_write_in_t;

endpackage