module execute_stage_tb;
  // Parameters
  parameter T = 10;

  // Inputs
  reg clk = 0;
  reg reset = 0;
  reg [15:0] Op1 = 0;
  reg [15:0] Op2 = 0;
  reg [1:0] ALUmode = 0;
  reg [1:0] carrySelect = 0;

  // Outputs
  wire [15:0] ALU_result = 0;
  wire [2:0] conditionCodeRegister = 0;

  execute_stage 
  execute_stage_dut (
    .clk (clk),
    .reset (reset),
    .Op1 (Op1),
    .Op2 (Op2),
    .AlUmode (ALUmode),
    .carrySelect (carrySelect),
    .result_r (result),
    .conditionCodeRegister_r (conditionCodeRegister)
  );

  initial begin
    Op1 = 15;
    Op2 = 24;
    ALUmode = 2'b00; // Add
    carrySelect = 2'b10;

    #T;
    Op1 = 2;
    Op2 = 5;
    ALUmode = 2'b00; // Add
    carrySelect = 2'b10;

    #T;
    Op1 = 42;
    Op2 = 7;
    ALUmode = 2'b01; // NOT
    carrySelect = 2'b00;

    #T;
    Op1 = 10;
    Op2 = 6;
    ALUmode = 2'b10; // Pass
    carrySelect = 2'b00;

    #T;
    Op1 = 25;
    Op2 = 20;
    ALUmode = 2'b11; // NOP
    carrySelect = 2'b00;

    #T;
    $finish;
  end

  always
    #5 clk = !clk ;

endmodule