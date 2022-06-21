// id: 109550022

`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALUOp_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALUOp_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemRead_o, MemWrite_o, MemtoReg_o;
 
//Internal Signals
reg    [3-1:0] ALUOp_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o, MemtoReg_o;
wire           Branch_o, MemRead_o, MemWrite_o;

//Parameter

//Main function

assign Branch_o = (instr_op_i == 6'b000100); // beq
assign MemRead_o = (instr_op_i == 6'b100011); // lw
assign MemWrite_o = (instr_op_i == 6'b101011); // sw

always @(instr_op_i) begin
    
	case(instr_op_i)
		//r-format
		6'b000000:
		begin
		   ALUOp_o <= 3'b100;
		   RegDst_o <= 2'b01;
		   MemtoReg_o <= 2'b00;
		   RegWrite_o <= 1;
		   ALUSrc_o <= 0;
		end

		//addi
		6'b001000:	
		begin
		   ALUOp_o <= 3'b000;
		   RegDst_o <= 2'b00;
		   MemtoReg_o <= 2'b00;
		   RegWrite_o <= 1;
		   ALUSrc_o <= 1;
		end

	   	//slti
		6'b001010:	
		begin
		   ALUOp_o <= 3'b010;
		   RegDst_o <= 2'b00;
		   MemtoReg_o <= 2'b00;
		   RegWrite_o <= 1;
		   ALUSrc_o <= 1;
		end

		//lw
		6'b100011:	
		begin
		   ALUOp_o <= 3'b000;
		   RegDst_o <= 2'b00;
		   MemtoReg_o <= 2'b01;
		   RegWrite_o <= 1;
		   ALUSrc_o <= 1;
		end

		//sw
		6'b101011:	
		begin
	   	   ALUOp_o <= 3'b000;
		   RegDst_o <= 2'b00;
		   MemtoReg_o <= 2'b00;
		   RegWrite_o <= 0;
		   ALUSrc_o <= 1;
		end

		//beq
		6'b000100:	
		begin
		   ALUOp_o <= 3'b001;
		   RegDst_o <= 2'b00;
		   MemtoReg_o <= 2'b00;
		   RegWrite_o <= 0;
		   ALUSrc_o <= 0;
		end
	endcase

end
endmodule