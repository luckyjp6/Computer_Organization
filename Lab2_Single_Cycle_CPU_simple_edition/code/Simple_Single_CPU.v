// id: 109550022

//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0]pc_old, pc, pc_new, pc_next_1, II;
wire [32-1:0]result, RSdata, RTdata, temp, temp_shift, ALU_src2;
wire RegWrite, ALUSrc, RegDst, Branch;
wire [5-1:0]Write_Reg;
wire [3-1:0]ALUCtrl, ALU_op;
wire zero;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_old) ,
	    .pc_out_o(pc)
	    );
	
Adder Adder1(
        .src1_i(32'd4),
	   .src2_i(pc),
        .sum_o(pc_new)
	    );
	
Instr_Memory IM(
       .pc_addr_i(pc),
	   .instr_o(II)
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(II[20:16]),
        .data1_i(II[15:11]),
        .select_i(RegDst),
        .data_o(Write_Reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i),
        .RSaddr_i(II[25:21]),  
        .RTaddr_i(II[20:16]),
        .RDaddr_i(Write_Reg),
        .RDdata_i(result),
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(II[31:26]),
	.RegWrite_o(RegWrite),
	.ALU_op_o(ALU_op),
	.ALUSrc_o(ALUSrc),
	.RegDst_o(RegDst),   
	.Branch_o(Branch)
	);

ALU_Ctrl AC(
        .funct_i(II[5:0]),   
        .ALUOp_i(ALU_op),
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(II[15:0]),
        .data_o(temp)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(temp),
        .select_i(ALUSrc),
        .data_o(ALU_src2)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	.src2_i(ALU_src2),
	.ctrl_i(ALUCtrl),
	.result_o(result),
        .zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(pc_new),     
	.src2_i(temp_shift),     
	.sum_o(pc_next_1)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(temp),
        .data_o(temp_shift)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_new),
        .data1_i(pc_next_1),
        .select_i(Branch&zero),
        .data_o(pc_old)
        );	
	
endmodule
		  


