module processor_tb;

    // Parameters
    parameter integer CLK_PERIOD = 20;
    // Ports
    reg clk = 0;
    reg rst = 0;
    wire [2:0] conditionCodeRegister;
    reg expected = 1'bx;
    reg [16 -1 :0] R [0:8 -1];

    processor
    processor_dut (
        .clk (clk),
        .rst (rst),
        .conditionCodeRegister (conditionCodeRegister)
    );

    integer i;	
    integer successCount = 0;

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            R[i] = processor_dut.decode_stage_dut.reg_file_dut.reg_file[i];
        end
    end

    initial begin
        begin
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            #CLK_PERIOD rst = 1;
            #CLK_PERIOD rst = 0;
            #CLK_PERIOD;
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b001 && R[1] == 1'd0) expected = 1; // LDM R1, 0
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b001 && R[2] == 16'b0000000000000010) expected = 1; // LDM R2, 2
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;
           
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b001) expected = 1; // NOP
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;
           
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b000 && R[1] == 16'b0000000000000010) expected = 1; // ADD R1, R2
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;
           
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b010 && R[1] == 16'b1111111111111101) expected = 1; // NOT R1
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;
           
            #(CLK_PERIOD * 5)
            expected = 1'b0;
            if (conditionCodeRegister == 3'b010 && processor_dut.memory_stage_dut.data_memory[2045] == 16'b0000000000000010) expected = 1; // STD R2, R1
            $display("Time = %t | R1 = %b | R2 = %b | Memory at R1 = %b | Carry = %b | Negative = %b | Zero = %b | Expected = %b", $time, 
			R[1], R[2], processor_dut.memory_stage_dut.data_memory[2045], conditionCodeRegister[2], conditionCodeRegister[1], conditionCodeRegister[0], expected);
            successCount = successCount + expected;

            $display("number of instructions passed = %d", successCount); 
           
            
            #(CLK_PERIOD)
            $stop;
        end
    end

    always
    #(CLK_PERIOD / 2)  clk = ! clk ;

endmodule
