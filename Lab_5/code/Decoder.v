// id: 109550022

`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite,
	ALUOp,
	ALUSrc,
	RegDst,
	Branch,
	branch_type,
	MemRead,
	MemWrite,
	MemtoReg
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output [3-1:0] ALUOp;
output [2-1:0] branch_type;
output         RegWrite, ALUSrc, RegDst, Branch, MemRead, MemWrite, MemtoReg;
 
//Internal Signals
reg    [3-1:0] ALUOp;
reg    [2-1:0] branch_type;
reg            ALUSrc, RegWrite, RegDst, MemtoReg, Branch;
wire           MemRead, MemWrite;

//Parameter

//Main function

assign MemRead = (instr_op_i == 6'b100011); // lw
assign MemWrite = (instr_op_i == 6'b101011); // sw

always @(instr_op_i) begin
	case(instr_op_i)
		//r-format
		6'b000000:
		begin
		   ALUOp <= 3'b100;
		   RegDst <= 2'b01;
		   MemtoReg <= 2'b00;
		   RegWrite <= 1;
		   ALUSrc <= 0;
		   Branch <= 0;
		   branch_type <= 2'b00;
		end

		//addi
		6'b001000:	
		begin
		   ALUOp <= 3'b000;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 1;
		   ALUSrc <= 1;
		   Branch <= 0;
		   branch_type <= 2'b00;
		end

	   	//slti
		6'b001010:	
		begin
		   ALUOp <= 3'b010;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 1;
		   ALUSrc <= 1;
		   Branch <= 0;
		   branch_type <= 2'b00;
		end

		//lw
		6'b100011:	
		begin
		   ALUOp <= 3'b000;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b01;
		   RegWrite <= 1;
		   ALUSrc <= 1;
		   Branch <= 0;
		   branch_type <= 2'b00;
		end

		//sw
		6'b101011:	
		begin
	   	   ALUOp <= 3'b000;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 0;
		   ALUSrc <= 1;
		   Branch <= 0;
		   branch_type <= 2'b00;
		end

		//beq
		6'b000100:	
		begin
		   ALUOp <= 3'b001;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 0;
		   ALUSrc <= 0;
		   Branch <= 1;
		   branch_type <= 2'b00;
		end
		
		// bne:
		6'b000101:  
		begin
		   ALUOp <= 3'b001;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 0;
		   ALUSrc <= 0;
		   Branch <= 1;
		   branch_type <= 2'b01;
		end
		
		// bge
		6'b000001:
		begin
		   ALUOp <= 3'b001;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 0;
		   ALUSrc <= 0;
		   Branch <= 1;
		   branch_type <= 2'b10;
		end
		
		// bgt
		6'b000111:
		begin
		   ALUOp <= 3'b001;
		   RegDst <= 2'b00;
		   MemtoReg <= 2'b00;
		   RegWrite <= 0;
		   ALUSrc <= 0;
		   Branch <= 1;
		   branch_type <= 2'b11;
		end
		
	endcase
end
endmodule