// id: 109550022

//Subject:     CO project 2 - Adder
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
module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
reg    [32-1:0]	 sum_o;

//Parameter
    
//Main function
// reference the behavioral 32-bit ALU in CO_Lab_2.pdf
always @(src1_i or src2_i) begin
	sum_o <= src1_i + src2_i;
end
endmodule





                    
                    