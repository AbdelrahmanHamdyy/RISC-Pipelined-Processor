onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processor_tb/clk
add wave -noupdate /processor_tb/CLK_PERIOD
add wave -noupdate /processor_tb/rst
add wave -noupdate /processor_tb/processor_dut/instruction
add wave -noupdate /processor_tb/processor_dut/reg_file_read_data1
add wave -noupdate /processor_tb/processor_dut/reg_file_read_data2
add wave -noupdate /processor_tb/processor_dut/ALUOp
add wave -noupdate /processor_tb/processor_dut/write_back_data
add wave -noupdate /processor_tb/processor_dut/decode_stage_dut/RegWrite_r
add wave -noupdate /processor_tb/processor_dut/decode_stage_dut/WB_ALUtoReg_r
add wave -noupdate /processor_tb/processor_dut/execute_stage_dut/result_r
add wave -noupdate /processor_tb/processor_dut/decode_stage_dut/reg_file_dut/reg_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {115 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 377
configure wave -valuecolwidth 102
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
configure wave -timelineunits ns
update
WaveRestoreZoom {73 ns} {203 ns}