module alu (
    input [1:0] carry_sel,
    input [1:0] alu_src2_select,
    input [15:0] read_data1,
    input [15:0] read_data2,
    input [1:0] alu_src1_select,
    input [4:0] shamt,
    input [3:0] ALU_Op,
    input [15:0] write_back_data,
    input [15:0] reg_data1_from_mem,
    input [15:0] reg_data2_from_mem,
    input flag_regsel,
    input flagreg_enable,
    input [2:0] conditions_from_memory_pop,

    output [2:0] flag_register,
    output reg [15:0] result
);

reg alu_carry;
wire carry, zero, negative;
wire [2:0] alu_flags;

wire [15:0] Op1, Op2;

assign Op1 =
(alu_src1_select == 2'b00) ? write_back_data :
(alu_src1_select == 2'b01) ? reg_data1_from_mem :
(alu_src1_select == 2'b10) ? read_data1 : 'bz;

assign Op2 =
(alu_src2_select == 2'b00) ? read_data2 :
(alu_src2_select == 2'b01) ? write_back_data :
(alu_src2_select == 2'b10) ? reg_data2_from_mem : 
(alu_src2_select == 2'b11) ? shamt : 'bz;

always @* begin
    alu_carry = 0;
    case (ALU_Op)
        4'b0000: result = ~Op1;
        
        4'b0001: {alu_carry, result} = Op1 + 1;

        4'b0010: {alu_carry, result} = Op1 - 1;

        4'b0011: {alu_carry, result} = Op1 + Op2;
        
        4'b0100: {alu_carry, result} = Op1 - Op2;
        
        4'b0101: {alu_carry, result} = Op1 & Op2;
        
        4'b0110: {alu_carry, result} = Op1 | Op2;
        
        4'b0111: {alu_carry, result} = Op1 << Op2;
        
        4'b1000: {alu_carry, result} = Op1 >> Op2;

        default: result = 16'b0;
    endcase
end

assign negative = result[15];
assign zero = (result == 0);

assign carry =
(carry_sel == 2'b00) ? alu_carry :
(carry_sel == 2'b01) ? 1 :
(carry_sel == 2'b10) ? 0 : 'bz;

assign alu_flags = {carry, negative, zero};

assign flag_register =
(flagreg_enable == 1'b1) ? (
    (flag_regsel == 1'b0) ? alu_flags :
    (flag_regsel == 1'b1) ? conditions_from_memory_pop :
    'bz) :
(flagreg_enable == 1'b0) ? 'bx : 'bz;

endmodule