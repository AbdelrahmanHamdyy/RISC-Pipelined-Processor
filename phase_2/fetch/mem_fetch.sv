module mem_fetch (
  input clk,
  input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
  input pc_write,
  input [31:0] pc_write_back_value,
  input clear_instruction, //overrides the current instruction with NOP (selector of the output mux)
  output [31:0] pc_plus_one,
  output [15:0] instruction,
  output [15:0] immediate_value
);

  reg [31:0] pc; // = 2**5; //program counter(initally 2^5)

  //  word width                memory entries  //TODO check this ya sarsora
  reg [15:0] instruction_memory [0: (2 ** 19) -1 ]; //instruction memeory of 2MB size, the first 2^5 entries are reserved for interrupts,
  // the rest is reserved of the instructions.

  assign instruction =
  (clear_instruction === 1'b1 )? 'h4000: //NOP
  instruction_memory[pc];

  assign immediate_value =   instruction_memory[pc];


  assign pc_plus_one = pc+1;

  always @(posedge clk, posedge reset)
  begin

    if (reset == 1)
      begin
        pc = 2**5;
      end
    else
      begin
        if(pc_write)
        begin
          pc = pc_write_back_value;
        end
        // pc = pc +1;
      end

  end

endmodule







