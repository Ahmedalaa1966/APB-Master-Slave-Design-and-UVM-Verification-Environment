onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB_TOP /tb_top/vif/presetn
add wave -noupdate -group TB_TOP /tb_top/vif/rdata_out
add wave -noupdate -group TB_TOP /tb_top/vif/done
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/rdata_out
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/done
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/transfer
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/wr_en
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/addr_in
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/wdata_in
add wave -noupdate -group DRIVER /tb_top/vif/drv_cb/drv_cb_event
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/presetn
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/transfer
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/wr_en
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/addr_in
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/wdata_in
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/rdata_out
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/done
add wave -noupdate -group MONITOR /tb_top/vif/mon_cb/mon_cb_event
add wave -noupdate -group DUT /tb_top/dut/pclk
add wave -noupdate -group DUT /tb_top/dut/presetn
add wave -noupdate -group DUT /tb_top/dut/transfer
add wave -noupdate -group DUT /tb_top/dut/wr_en
add wave -noupdate -group DUT /tb_top/dut/addr_in
add wave -noupdate -group DUT /tb_top/dut/wdata_in
add wave -noupdate -group DUT /tb_top/dut/rdata_out
add wave -noupdate -group DUT /tb_top/dut/done
add wave -noupdate -group DUT /tb_top/dut/paddr
add wave -noupdate -group DUT /tb_top/dut/psel
add wave -noupdate -group DUT /tb_top/dut/penable
add wave -noupdate -group DUT /tb_top/dut/pwrite
add wave -noupdate -group DUT /tb_top/dut/pwdata
add wave -noupdate -group DUT /tb_top/dut/pready
add wave -noupdate -group DUT /tb_top/dut/prdata
add wave -noupdate -group DUT /tb_top/dut/u_master/paddr
add wave -noupdate -group DUT /tb_top/dut/u_master/psel
add wave -noupdate -group DUT /tb_top/dut/u_master/penable
add wave -noupdate -group DUT /tb_top/dut/u_master/pwrite
add wave -noupdate -group DUT /tb_top/dut/u_master/pwdata
add wave -noupdate -group DUT /tb_top/dut/u_master/rdata_out
add wave -noupdate -group DUT /tb_top/dut/u_master/done
add wave -noupdate -group DUT /tb_top/dut/u_master/state
add wave -noupdate -group DUT /tb_top/dut/u_master/next_state
add wave -noupdate -group DUT /tb_top/dut/u_master/addr_q
add wave -noupdate -group DUT /tb_top/dut/u_master/wdata_q
add wave -noupdate -group DUT /tb_top/dut/u_master/write_q
add wave -noupdate -group DUT /tb_top/dut/u_slave/pready
add wave -noupdate -group DUT /tb_top/dut/u_slave/prdata
add wave -noupdate -group DUT /tb_top/dut/u_slave/idx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 399
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {289390 ps}
