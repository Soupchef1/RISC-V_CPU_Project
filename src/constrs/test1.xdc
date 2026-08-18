set_false_path -from [get_pins your_instance_name/inst/mig_7series_0/u_memory_mig_7series_0_0_mig/u_memc_ui_top_axi/mem_intfc0/ddr_phy_top0/u_ddr_calib_top/init_calib_complete_reg/C] -to [get_pins boot/controller/calib_sync1_reg/D]
set_false_path -from [get_pins your_instance_name/inst/mig_7series_0/u_memory_mig_7series_0_0_mig/u_memc_ui_top_axi/mem_intfc0/ddr_phy_top0/u_ddr_calib_top/init_calib_complete_reg/C] -to [get_pins boot/controller/calib_sync1_reg/D]








connect_debug_port u_ila_0/probe0 [get_nets [list {mm2s_frame_ptr_out_0[0]} {mm2s_frame_ptr_out_0[1]} {mm2s_frame_ptr_out_0[2]} {mm2s_frame_ptr_out_0[3]} {mm2s_frame_ptr_out_0[4]} {mm2s_frame_ptr_out_0[5]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list locked_0]]
connect_debug_port u_ila_0/probe6 [get_nets [list mm2s_introut_0]]

connect_debug_port u_ila_0/probe1 [get_nets [list m_axis_mm2s_tlast_0]]


connect_debug_port u_ila_0/probe0 [get_nets [list {status_0[0]} {status_0[1]} {status_0[2]} {status_0[3]} {status_0[4]} {status_0[5]} {status_0[6]} {status_0[7]} {status_0[8]} {status_0[9]} {status_0[10]} {status_0[11]} {status_0[12]} {status_0[13]} {status_0[14]} {status_0[15]} {status_0[16]} {status_0[17]} {status_0[18]} {status_0[19]} {status_0[20]} {status_0[21]} {status_0[22]} {status_0[23]} {status_0[24]} {status_0[25]} {status_0[26]} {status_0[27]} {status_0[28]} {status_0[29]} {status_0[30]} {status_0[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list m_axis_mm2s_tuser_0]]
connect_debug_port u_ila_0/probe2 [get_nets [list m_axis_mm2s_tvalid_0]]
connect_debug_port u_ila_0/probe3 [get_nets [list s_axis_video_tready_0]]

