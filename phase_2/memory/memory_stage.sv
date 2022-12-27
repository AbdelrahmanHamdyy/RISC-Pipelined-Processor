module memory_stage (
  input clk, reset,memory_read, memory_write, memory_push, memory_pop,
  input [15:0] std_address, ldd_address, //read data1 & read data
  input [1:0] memory_address_select, memory_write_src_select,
  input[31:0] pc,
  input [2:0] flags,
  output [15:0] data_r, //wire on the inside
  output [31:0] shift_reg, //reg on the inside

  //passing

  input [15:0] LDM_value,
  output [15:0] LDM_value_out,

  input [15:0] alu_value,
  output [15:0] alu_value_out,


  input reg_write,
  output reg_write_out,

  input [1:0] wb_sel,
  output [1:0] wb_sel_out,

  input outport_enable,
  output outport_enable_out,

  input [2:0] reg_write_address,
  output [2:0] reg_write_address_out


);

  var_reg #(.size(3))
  reg_write_address_reg (
    .D (reg_write_address ),
    .clk (clk ),
    .Q  (reg_write_address_out),
    .rst (reset)
  );
  
  var_reg #(.size(1))
  outport_enable_reg (
    .D (outport_enable ),
    .clk (clk ),
    .Q  (outport_enable_out),
    .rst (reset)
  );

  var_reg #(.size(16))
  alu_value_reg (
    .D (alu_value ),
    .clk (clk ),
    .Q  (alu_value_out),
    .rst (reset)
  );
  var_reg #(.size(2))
  wb_sel_reg (
    .D (wb_sel ),
    .clk (clk ),
    .Q  (wb_sel_out),
    .rst (reset)
  );

  var_reg #(.size(1))
  reg_write_reg (
    .D (reg_write ),
    .clk (clk ),
    .Q  (reg_write_out),
    .rst (reset)
  );


  var_reg #(.size(16))
  LDM_value_reg (
    .D (LDM_value ),
    .clk (clk ),
    .Q  (LDM_value_out),
    .rst (reset)
  );

  wire [15:0] data;
  var_reg #(.size(16))
  data_reg (
    .D (data ),
    .clk (clk ),
    .Q  (data_r),
    .rst (reset)
  );

  memory_stage_without_buffers
  memory_stage_without_buffers_dut (
    .clk (clk ),
    .reset (reset ),
    .memory_read (memory_read ),
    .memory_write (memory_write ),
    .memory_push (memory_push ),
    .memory_pop (memory_pop ),
    .std_address (std_address ),
    .ldd_address (ldd_address ),
    .memory_address_select (memory_address_select ),
    .memory_write_src_select (memory_write_src_select ),
    .pc (pc ),
    .flags (flags ),
    .data  ( data),
    .shift_reg(shift_reg)
  );

endmodule
