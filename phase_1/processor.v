module processor(
    input clk,
    input rst
);

    wire [15:0] instruction;

    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (rst ),
        .instruction_r  ( instruction)
    );

    wire[15:0] write_back_data;

    wire [1:0] ALUOp;
    wire  WB_ALUtoReg, RegWrite, MemRead, MemWrite;
    wire  [15:0] reg_file_read_data1,reg_file_read_data2;
    wire  [15:0] sign_extend_output;

    wire RegWrite_from_mem;
    wire [2:0] write_address_from_wb;
    wire [2:0] write_address_from_decode;
    decode_stage
    decode_stage_dut (
        .clk (clk ),
        .rst (rst ),
        .instruction (instruction ),
        .regFile_write_data (write_back_data),
        .ALUOp_r (ALUOp ),
        .WB_ALUtoReg_r (WB_ALUtoReg ),
        .RegWrite_r (RegWrite ),
        .MemRead_r (MemRead ),
        .MemWrite_r (MemWrite ),
        .reg_file_read_data1_r (reg_file_read_data1 ),
        .reg_file_read_data2_r (reg_file_read_data2 ),
        .sign_extend_output_r  ( sign_extend_output),
        .regFile_write_from_wb(RegWrite_from_mem),
        .reg_write_address_from_wb(write_address_from_wb),
        .reg_write_address_r(write_address_from_decode)

    );


    wire RegWrite_from_ex;

    wire  [15:0] ALU_out;

    wire [2:0] write_address_to_mem;
    execute_stage
    execute_stage_dut (
        .clk (clk ),
        .reset (reset ),
        .Op1 (reg_file_read_data1 ),
        .Op2 (reg_file_read_data2 ),
        .AlUmode (ALUOp ),
        .result_r  ( ALU_out),
        .RegWrite_r (RegWrite_from_ex ),
        .RegWrite(RegWrite),
        .reg_write_address_to_memory(write_address_to_mem),
        .reg_write_address_from_decode(write_address_from_decode)

    );


    wire [15:0] mem_out;
    memory_stage
    memory_stage_dut (
        .clk (clk ),
        .reset (reset ),
        . memory_read ( MemRead ),
        . memory_write ( MemWrite ),
        . memory_push ( 1'b0 ),
        . memory_pop ( 1'b0 ),
        .address (ALU_out ),
        . write_data (reg_file_read_data2),
        .data_r  ( mem_out),
        .RegWrite(RegWrite_from_ex),
        .RegWrite_r(RegWrite_from_mem),
        .reg_write_address_r_to_wb(write_address_from_wb),
        .reg_write_address_from_ex(write_address_to_mem)
    );


    write_back_stage
    write_back_stage_dut (
        .sel (WB_ALUtoReg ),
        .immediate_value (sign_extend_output ),
        . alu_value ( ALU_out ),
        .data  ( write_back_data)
    );



endmodule 
