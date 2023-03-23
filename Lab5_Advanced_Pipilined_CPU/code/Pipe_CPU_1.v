// id: 109550022

`timescale 1ns / 1ps
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire [32-1:0] pc_next, pc_in, pc_out, inst;
wire PCSrc;

wire [32-1:0] pc_next_ID, inst_ID;

wire [32-1:0] Read_data_1, Read_data_2, after_extend;
wire [3-1:0] ALUOp;
wire [2-1:0] branch_type;
wire  RegWrite, ALUSrc, RegDst, Branch, MemRead, MemWrite, MemtoReg;

wire [32-1:0] pc_next_EX, Read_data_1_EX, Read_data_2_EX, after_extend_EX, ALU_src2_EX, inst_EX;
wire [3-1:0] ALUOp_EX;
wire [2-1:0] branch_type_EX;
wire MemtoReg_EX, Branch_EX, MemRead_EX, MemWrite_EX, RegDst_EX, ALUSrc_EX, RegWrite_EX;

wire [32-1:0] after_shift, ALU_src1, ALU_src21, ALU_src2, ALU_result, pc_1;
wire [5-1:0] Write_Reg;
wire [4-1:0] ALUCtrl;
wire zero;

wire [32-1:0] pc_1_MEM, ALU_result_MEM;
wire [5-1:0] Write_Reg_MEM;
wire [2-1:0] branch_type_MEM;
wire MemtoReg_MEM, Branch_MEM, MemRead_MEM, MemWrite_MEM, RegWrite_MEM, zero_MEM;

wire [32-1:0] Mem_data;

wire [32-1:0] Mem_data_WB, ALU_result_WB;
wire [5-1:0] Write_Reg_WB;
wire RegWrite_WB, MemtoReg_WB;

wire [32-1:0] Mem_mux_data;

wire [32-1:0] Write_data, Write_data_MEM;
wire [2-1:0] ALU_source_1, ALU_source_2;
wire branch, PC_Write, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush;

/**** Hazard ****/
Forwarding Forward(
        .RegRd_MEM(Write_Reg_MEM),
        .RegRd_WB(Write_Reg_WB),
        .RegWrite_MEM(RegWrite_MEM),
        .RegWrite_WB(RegWrite_WB),
        .RegRs_EX(inst_EX[25:21]),
        .RegRt_EX(inst_EX[20:16]),
        .ALU_src1_select(ALU_source_1),
        .ALU_src2_select(ALU_source_2)
);

Hazard Hazard(
        .inst_ID(inst_ID),
        .RegRt_EX(inst_EX[20:16]),
        .MemRead_EX(MemRead_EX),
        .branch(branch && Branch_MEM),
        .PC_Write(PC_Write),
        .IF_ID_Write(IF_ID_Write),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush),
        .EX_MEM_Flush(EX_MEM_Flush)
);

/**** IF stage ****/
MUX_4to1 #(.size(1)) MUX_branch(
        .data0_i(zero_MEM), //  beq
        .data1_i(~zero_MEM), // bne
        .data2_i(~ALU_result_MEM[31]), // bge 
        .data3_i(~ (zero_MEM | ALU_result_MEM[31])), // bgt
        .branch_type(branch_type_MEM),
        .branch(branch)
);

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next), // +4
        .data1_i(pc_1_MEM), // branch
        .select_i(Branch_MEM && branch),
        .data_o(pc_in)
);

ProgramCounter PC(
        .clk_i(clk_i),
        .rst_i (rst_i),
        .pc_in_i(pc_in),
        .PC_Write(PC_Write),
        .pc_out_o(pc_out)
);
	
Adder Adder1(
        .src1_i(pc_out),
        .src2_i(32'd4),
        .sum_o(pc_next)
);
	
Instruction_Memory IM(
        .addr_i(pc_out),
	.instr_o(inst)
);

//data
Pipe_Reg #(.size(32+32)) IF_ID(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(IF_ID_Write),
        .flush(IF_ID_Flush),
        .data_i({pc_next, inst}),
        .data_o({pc_next_ID, inst_ID})
);

/////////////////////////////////////////////////////////////////////////////////
/**** ID stage ****/
Reg_File RF(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(inst_ID[25:21]),
        .RTaddr_i(inst_ID[20:16]),
        .RDaddr_i(Write_Reg_WB),
        .RDdata_i(Mem_mux_data),
        .RegWrite_i(RegWrite_WB),
        .RSdata_o(Read_data_1),
        .RTdata_o(Read_data_2)
);

Sign_Extend SE(
        .data_i(inst_ID[15:0]),
        .data_o(after_extend)
);

Decoder Decoder(
        .instr_op_i(inst_ID[31:26]), 
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .Branch(Branch),
        .branch_type(branch_type),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg)
);

//data
Pipe_Reg #(.size(32*5)) ID_EX_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(ID_EX_Flush),
        .data_i({pc_next_ID, Read_data_1, Read_data_2, after_extend, inst_ID}),        
        .data_o({pc_next_EX, Read_data_1_EX, Read_data_2_EX, after_extend_EX, inst_EX})
);
//control signal
Pipe_Reg #(.size(7+2+3)) ID_EX_ctrl(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(ID_EX_Flush),
        .data_i({MemtoReg, Branch, branch_type, MemRead, MemWrite, RegDst, ALUOp, ALUSrc, RegWrite}),
        .data_o({MemtoReg_EX, Branch_EX, branch_type_EX, MemRead_EX, MemWrite_EX, RegDst_EX, ALUOp_EX, ALUSrc_EX, RegWrite_EX})
);

/////////////////////////////////////////////////////////////////////////////////
/**** EX stage ****/
Shift_Left_Two_32 Shifter(
        .data_i(after_extend_EX),
        .data_o(after_shift)
);


MUX_3to1 #(.size(32)) MUX_source1(
        .data0_i(Read_data_1_EX),
        .data1_i(Mem_mux_data),
        .data2_i(ALU_result_MEM),
        .select_i(ALU_source_1),
        .data_o(ALU_src1)
);

MUX_3to1 #(.size(32)) MUX_source2(
        .data0_i(Read_data_2_EX),
        .data1_i(Mem_mux_data),
        .data2_i(ALU_result_MEM),
        .select_i(ALU_source_2),
        .data_o(ALU_src21)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(ALU_src21),
        .data1_i(after_extend_EX),
        .select_i(ALUSrc_EX),
        .data_o(ALU_src2)
);

ALU ALU_R(
        .src1_i(ALU_src1),
        .src2_i(ALU_src2),
        .ctrl_i(ALUCtrl),
        .result_o(ALU_result),
        .zero_o(zero)
);

Adder Adder_lwsw(
        .src1_i(pc_next_EX),
        .src2_i(after_shift),
        .sum_o(pc_1)
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(inst_EX[20:16]),
        .data1_i(inst_EX[15:11]),
        .select_i(RegDst_EX),
        .data_o(Write_Reg)
);

ALU_Ctrl AC(
        .funct_i(inst_EX[5:0]),
        .ALUOp_i(ALUOp_EX),
        .ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) choose_Write_Data(
        .data0_i(Read_data_2_EX),
        .data1_i(ALU_result_MEM),
        .select_i(ALU_source_2[1]),
        .data_o(Write_data)
);

//data
Pipe_Reg #(.size(32*3+5)) EX_MEM_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(EX_MEM_Flush),
        .data_i({pc_1, Write_data, ALU_result, Write_Reg}),
        .data_o({pc_1_MEM, Write_data_MEM, ALU_result_MEM, Write_Reg_MEM})
);

//control signal
Pipe_Reg #(.size(6+2)) EX_MEM_ctrl(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(EX_MEM_Flush),
        .data_i({MemtoReg_EX, Branch_EX, branch_type_EX, MemRead_EX, MemWrite_EX, RegWrite_EX, zero}),
        .data_o({MemtoReg_MEM, Branch_MEM, branch_type_MEM, MemRead_MEM, MemWrite_MEM, RegWrite_MEM, zero_MEM})
);
/////////////////////////////////////////////////////////////////////////////////
/**** MEM stage ****/

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALU_result_MEM),
        .data_i(Write_data_MEM),
        .MemRead_i(MemRead_MEM),
        .MemWrite_i(MemWrite_MEM),
        .data_o(Mem_data)
);

//data
Pipe_Reg #(.size(32*2+5)) MEM_WB_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(1'b0),
        .data_i({Mem_data, ALU_result_MEM, Write_Reg_MEM}),
        .data_o({Mem_data_WB, ALU_result_WB, Write_Reg_WB})
);
//control signal
Pipe_Reg #(.size(2)) MEM_WB_ctrl(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pipe_reg_write(1'b1),
        .flush(1'b0),
        .data_i({RegWrite_MEM, MemtoReg_MEM}),
        .data_o({RegWrite_WB, MemtoReg_WB})
);

/////////////////////////////////////////////////////////////////////////////////
/**** WB stage ****/
MUX_2to1 #(.size(32)) Mux_Write_Data(
        .data0_i(ALU_result_WB),
        .data1_i(Mem_data_WB),
        .select_i(MemtoReg_WB),
        .data_o(Mem_mux_data)
);
endmodule

