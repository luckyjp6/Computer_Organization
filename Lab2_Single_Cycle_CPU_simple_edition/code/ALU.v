// id: 109550022

//Subject:     CO project 2 - ALU
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
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input signed [32-1:0]  src1_i;
input signed [32-1:0]  src2_i;
input [3-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
// reference the behavioral 32-bit ALU in CO_Lab_2.pdf
assign zero_o = (result_o == 0);
always @(src1_i or src2_i or ctrl_i) begin
    
    case (ctrl_i)
        0: result_o <= (src1_i & src2_i);
        1: result_o <= (src1_i | src2_i);
        2: result_o <= (src1_i + src2_i);
        6: result_o <= (src1_i - src2_i);
        7: result_o <= (src1_i < src2_i ? 1 : 0);
        default: result_o <= 1;
	endcase
//	$display("ctrl: ", ctrl_i," zero: ", zero_o, " sr1: ", src1_i, " src2: ", src2_i, " result: ", result_o);
end

endmodule                  