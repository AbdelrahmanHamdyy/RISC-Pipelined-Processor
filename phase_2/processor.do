log * -r
mem load -i D:/arch_project/RISC-pipelined-processor/assembler/output.mem /processor/fetch_stage_dut/mem_fetch_dut/instruction_memory
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/rst 0
run
run 
force -freeze sim:/processor/input_port 'h5
run
force -freeze sim:/processor/input_port 'h19
run
force -freeze sim:/processor/input_port 'hFFFF
run
force -freeze sim:/processor/input_port 'hF320
run
