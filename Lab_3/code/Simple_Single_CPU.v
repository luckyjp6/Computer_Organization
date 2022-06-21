// id: 109550022

module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0]pc_in, pc_out, pc_next, inst, after_extend, after_shift, pc_jump, pc_branch, pc_n_jump, pc_mux_0;
wire [32-1:0]Mem_data, Read_data_1, Read_data_2, ALU_src2, Mem_mux_data, ALU_result;
wire [5-1:0]Write_Reg;
wire [2-1:0]RegDst, MemtoReg;
wire Branch, MemRead, MemWrite, ALUSrc, RegWrite, jump, jump_reg;
wire zero;
wire [3-1:0]ALUOp;
wire [4-1:0]ALUCtrl;

//Greate componentes
assign jump_reg = (inst[31:26] == 6'd0 && inst[5:0] == 6'd8);

ProgramCounter PC(
        .clk_i(clk_i),
	.rst_i (rst_i),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
);
	
Adder Adder1(
        .src1_i(pc_out),
	.src2_i(32'd4),
	.sum_o(pc_next)
);
	
Instr_Memory IM(
        .pc_addr_i(pc_out),
	.instr_o(inst)
);

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(inst[20:16]),
        .data1_i(inst[15:11]),
        .data2_i(5'd31),
        .select_i(RegDst),
        .data_o(Write_Reg)
);	

MUX_3to1 #(.size(32)) Mux_Write_Data(
        .data0_i(ALU_result),
        .data1_i(Mem_data),
        .data2_i(pc_next),
        .select_i(MemtoReg),
        .data_o(Mem_mux_data)
);

Reg_File Registers(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(inst[25:21]),
        .RTaddr_i(inst[20:16]),
        .RDaddr_i(Write_Reg),
        .RDdata_i(Mem_mux_data),
        .RegWrite_i(RegWrite && (~jump_reg)),
        .RSdata_o(Read_data_1),
        .RTdata_o(Read_data_2)
);
	
Decoder Decoder(
        .instr_op_i(inst[31:26]), 
        .RegWrite_o(RegWrite),
        .ALUOp_o(ALUOp),
        .ALUSrc_o(ALUSrc),
        .RegDst_o(RegDst),
        .Branch_o(Branch),
        .jump_o(jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg)
);

ALU_Ctrl AC(
        .funct_i(inst[5:0]),
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALUCtrl)
);
	
Sign_Extend SE(
        .data_i(inst[15:0]),
        .data_o(after_extend)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Read_data_2),
        .data1_i(after_extend),
        .select_i(ALUSrc),
        .data_o(ALU_src2)
);	
		
ALU ALU(
        .src1_i(Read_data_1),
        .src2_i(ALU_src2),
        .ctrl_i(ALUCtrl),
        .result_o(ALU_result),
        .zero_o(zero)
);
	
Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(ALU_result),
        .data_i(Read_data_2),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(Mem_data)
);

Adder Adder2(
        .src1_i(pc_next),
	.src2_i(after_shift),
	.sum_o(pc_branch)
);
		
Shift_Left_Two_32 Shifter(
        .data_i(after_extend),
        .data_o(after_shift)
);
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_mux_0),
        .data1_i(Read_data_1),
        .select_i(jump_reg),
        .data_o(pc_in)
);

MUX_2to1 #(.size(32)) MUX_PC_jump(
        .data0_i(pc_n_jump),
        .data1_i({pc_next[31:28], inst[25:0], 2'b00}),
        .select_i(jump),
        .data_o(pc_mux_0)
);

MUX_2to1 #(.size(32)) Mux_PC_next(
        .data0_i(pc_next),
        .data1_i(pc_branch),
        .select_i(Branch && zero),
        .data_o(pc_n_jump)
);

endmodule