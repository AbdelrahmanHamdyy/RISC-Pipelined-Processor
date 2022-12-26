module memory_stage_without_buffers (
    input clk, reset,memory_read, memory_write, memory_push, memory_pop,
    input [15:0] std_address, ldd_address, //read data1 & read data
    input [1:0] memory_address_select, memory_write_src_select,
    input[31:0] pc,
    input [2:0] flags,
    output [15:0] data,
    output [31:0] shift_reg
    // inputs to ust pass
    // input RegWrite,
    // output RegWrite_r,
    // input[2:0] reg_write_address_from_ex,
    // output[2:0] reg_write_address_r_to_wb,
    // input [15:0] sign_extend_from_ex,
    // output [15:0] sign_extend_to_wb,
    // input [15:0] alu_result_from_ex,
    // output [15:0] alu_result_to_wb,
    // input write_back_select_from_ex,
    // output write_back_select_to_wb

  );


  // read - write - push - pop
  reg [10:0] final_address;
  wire [15:0] write_data;

  assign write_data =
  (memory_write_src_select == 2'b00) ? {13'b0,flags} :
  (memory_write_src_select == 2'b01) ? pc[31:16] :
  (memory_write_src_select == 2'b10) ? pc[15:0] :
  (memory_write_src_select == 2'b11) ? std_address : 'bz;
 

  reg [31:0] temp_shift_reg;
  reg  [31:0] sp; //stack pointer pointing at the last entry // @suppress "Register initialization in declaration. Consider using an explicit reset instead"
  reg [15:0] data_memory [0: (2 ** 9) -1]; //data memory of 4KB

  assign data = (memory_read == 1) ? data_memory[final_address] : 'bz;
  assign shift_reg = temp_shift_reg;
  // read? ldd ldm pop
  

  always @(posedge clk)
  begin

    if(reset)
    begin
      sp = (2**9)-1;
      temp_shift_reg = 0;
    end

    else
    begin

      if (memory_push == 1'b1 && sp > 0)
      begin
        sp = sp - 1;
      end

      if (memory_pop == 1'b1 && sp < 2**9 -2)
      begin
        sp = sp + 1;
      end


      case (memory_address_select)
          2'b00: final_address = sp;
          2'b01: final_address = ldd_address[10:0]; 
          2'b10: final_address = std_address[10:0]; 
          // default:           
        endcase
  
      if(memory_write)
      begin
        data_memory[final_address] = write_data;
      end

      if(memory_read)
      begin
      temp_shift_reg = temp_shift_reg>>16;
      temp_shift_reg = {data, temp_shift_reg[15:0]};
      end
    end

  end

endmodule