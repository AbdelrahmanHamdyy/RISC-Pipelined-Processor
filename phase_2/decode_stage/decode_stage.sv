module decode_stage(
    input clk,reset,
    input flush_decode,
    input interrupt_signal,
    input [15:0] instruction,
    input [32-1:0]PC,
    output  reg_write_r, mem_read_r, mem_write_r, mem_pop_r,mem_push_r,
    output   flag_reg_select_r,pc_choose_memory_r,
    output [2 :0] jump_selector_r,
    output [3:0] r_scr_r,r_dst_r,r_scr_fetch,r_dst_fetch,
    output  [1:0] mem_src_select_r,
    output  [3:0] ALUOp_r,
    output  [1:0] wb_sel_r,
    output  [1:0] mem_addsel_r,
    output  [1:0] carry_sel_r,
    ////////////////////////////
    input [31:0] pc_plus_one_fetch,
    output [31:0] pc_plus_one_s_dec,

    output pc_choose_interrupt_r,
    output fetch_stall_cu,
    output  outport_enable_r,
    output  inport_sel_r, alu_srcsel_r,
    output  flagreg_enable_r,
    output  clear_instruction,
    input reg_write_wb,
    input[15:0] reg_write_data_from_wb,
    input[2:0] reg_write_address_from_wb,
    output[2:0] reg_write_address_r,
    output[15:0] reg_file_read_data1,
    output[15:0] reg_file_read_data2,
    output [31:0] pc_plus_one_dec,
    output pc_write_cu,
    input [3:0] shamt_out,

    input [15:0] ldm_value_fetch,
    output [15:0] ldm_value_dec,
    output  pc_plus_1_or_pc_minus_1_r

  );


  wire pc_plus_1_or_pc_minus_1;
  wire [15:0] reg_file_read_data1_s;
  wire [15:0] reg_file_read_data2_s;
  wire pc_choose_PC;
  wire reg_write, mem_read, mem_write, mem_pop,mem_push;
  wire flag_reg_select,pc_choose_memory;
  wire [2:0] jump_selector;
  wire [3:0] r_scr,r_dst;
  wire [1:0] mem_src_select;
  wire [3:0] ALUOp;
  wire [1:0] wb_sel;
  wire [1:0] mem_addsel;
  wire [1:0] carry_sel;
  wire pc_choose_interrupt;

  wire outport_enable;
  wire inport_sel;
  wire flagreg_enable;

  assign r_scr_fetch = r_scr;
  assign r_dst_fetch = r_dst;


  assign pc_plus_one_s_dec = (pc_choose_PC === 1'b1)? pc_plus_one_fetch - 1 : pc_plus_one_fetch;

  var_reg #(
            .size(16)
          ) ldm_fetch(
            .D(ldm_value_fetch),
            .clk(clk),
            .rst(reset),
            .Q(ldm_value_dec)
          );

  var_reg #(
            .size(32)
          ) var_reg_instance123(
            .D({reg_file_read_data1_s, reg_file_read_data2_s}),
            .clk(clk),
            .rst(reset),
            .Q({reg_file_read_data1, reg_file_read_data2})
          );

  var_reg #(
            .size(32)
          ) var_reg_instance1234(
            .D(PC),
            .clk(clk),
            .rst(reset),
            .Q(pc_plus_one_dec)
          );

  var_reg_with_mux #(
                     .size(7)
                   ) var_reg_instance(
                     .D({instruction[3:0], flag_reg_select, pc_choose_interrupt,pc_plus_1_or_pc_minus_1}),
                     .clk(clk),
                     .rst(reset),
                     .mux_clear(flush_decode),
                     .Q({shamt_out, flag_reg_select_r,pc_choose_interrupt_r,pc_plus_1_or_pc_minus_1_r})
                   );

  var_reg #(
            .size(3)
          ) var_reg_instance2(
            .D(instruction[10:8] ),
            .clk(clk),
            .rst(reset),
            .Q(reg_write_address_r)
          );
  var_reg_with_mux #(.size(6))
                   var_reg_1 (
                     .D ({reg_write, mem_read, mem_write, mem_pop,mem_push, pc_choose_memory} ),
                     .clk (clk ),
                     .mux_clear(flush_decode),
                     .Q  ({ reg_write_r, mem_read_r, mem_write_r, mem_pop_r,mem_push_r , pc_choose_memory_r} ),
                     .rst (reset)
                   );

  var_reg_with_mux #(.size(20))
                   var_reg_2 (
                     .D ({jump_selector,r_scr,r_dst, mem_src_select, ALUOp, wb_sel,pc_write} ),
                     .clk (clk ),
                     .mux_clear(flush_decode),
                     .Q  ({ jump_selector_r,r_scr_r,r_dst_r,mem_src_select_r,ALUOp_r,wb_sel_r,pc_write_r} ),
                     .rst (reset)
                   );

  var_reg_with_mux #(.size(5))
                   var_reg_3 (
                     .D ({mem_addsel,carry_sel,alu_srcsel} ),
                     .clk (clk ),
                     .mux_clear(flush_decode),
                     .Q  ({ mem_addsel_r,carry_sel_r,alu_srcsel_r} ),
                     .rst (reset)
                   );

  var_reg_with_mux #(.size(3))
                   var_reg_4 (
                     .D ({outport_enable,inport_sel,flagreg_enable} ),
                     .clk (clk ),
                     .mux_clear(flush_decode),
                     .Q  ({ outport_enable_r, inport_sel_r, flagreg_enable_r} ),
                     .rst (reset)
                   );


  sm control_unit(
       .clk(clk),
       .reset(reset),
       .pc_choose_interrupt(pc_choose_interrupt),
       .interrupt_signal(interrupt_signal),
       .instruction(instruction),
       .PC(PC),
       .reg_write(reg_write),
       .mem_read(mem_read),
       .mem_write(mem_write),
       .mem_pop(mem_pop),
       .mem_push(mem_push),
       .pc_choose_PC(pc_choose_PC),
       .clear_instruction(clear_instruction),
       .flag_reg_select(flag_reg_select),
       .pc_choose_memory(pc_choose_memory),
       .jump_selector(jump_selector),
       .r_scr(r_scr),
       .r_dst(r_dst),
       .stall_fetch_from_cu(fetch_stall_cu),
       .mem_src_select(mem_src_select),
       .ALUOp(ALUOp),
       .wb_sel(wb_sel),
       .mem_addsel(mem_addsel),
       .carry_sel(carry_sel),
       .alu_srcsel(alu_srcsel),
       .pc_plus_1_or_pc_minus_1(pc_plus_1_or_pc_minus_1),
       .outport_enable(outport_enable),
       .inport_sel(inport_sel),
       .flagreg_enable(flagreg_enable),
       .pc_write_cu(pc_write_cu)
     );




  reg_file
    #(
      .WIDTH(16 ),
      .N_REGS (
        8 )
    )
    reg_file_dut (
      .clk (clk ),
      .rst (reset ),
      .RegWrite (reg_write_wb ),
      .write_address (reg_write_address_from_wb),
      .write_data (reg_write_data_from_wb ),
      // 12 11 10 9 8 7 6 5 4 3 2 1 0
      .read_address1 (instruction[10:8] ),
      .read_address2 (instruction[7:5] ),
      .read_data1 (  reg_file_read_data1_s ),
      .read_data2  ( reg_file_read_data2_s)
    );

endmodule
