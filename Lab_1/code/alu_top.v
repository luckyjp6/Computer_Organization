`timescale 1ns/1ps
// student ID : 109550022
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout        //1 bit carry out(output)
               );

    input         src1;
    input         src2;
    input         less;
    
    input         A_invert;
    input         B_invert;
    input         cin;
    input [2-1:0] operation;
    
    output        result;
    output        cout;
    reg           result, cout;
    reg          s1, s2;
     
    
    always@(*) begin
        if (A_invert) s1 = ~src1; else s1 = src1;
        if (B_invert) s2 = ~src2; else s2 = src2;
        case(operation)
            2'b00:begin result = s1 && s2;cout = 0; end
            2'b01:begin result = s1 || s2; cout = 0; end
            2'b10:begin {cout, result} = (s1 + s2 + cin); end
            2'b11:begin result = less; cout = (s1&s2) | (s1&cin) | (s2&cin); end
	endcase
    end

endmodule