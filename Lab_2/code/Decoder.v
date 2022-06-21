// id: 109550022

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

//Main function
always @(instr_op_i) begin
	RegWrite_o <= ~instr_op_i[2];
	ALU_op_o[2] <= (instr_op_i == 0);
	ALU_op_o[1] <= instr_op_i[3] & (~instr_op_i[1]);
	ALU_op_o[0] <= instr_op_i[2];
	ALUSrc_o <= instr_op_i[3];
	RegDst_o <= (instr_op_i == 0);
	Branch_o <= instr_op_i[2];
    $display ( "RegWrite_o: ", RegWrite_o, " ALU_op_o: ", ALU_op_o, " ALUSrc_o: ", ALUSrc_o, " RegDst_o: ", RegDst_o, " Branch_o: ", Branch_o);
end
endmodule