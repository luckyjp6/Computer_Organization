`timescale 1ns/1ps
// student ID : 109550022
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

    input           clk;
    input           rst_n;
    input  [32-1:0] src1;
    input  [32-1:0] src2;
    input   [4-1:0] ALU_control;
    
    output [32-1:0] result;
    output          zero;
    output          cout;
    output          overflow;
    
    reg first_cin;
    reg A_invert, B_invert;
    reg [2-1:0] operation;
    reg [32-1:0] result;
    reg less, overflow, zero, cout;
    reg A, B;
    wire set;
    wire [32-1:0] carry;
    wire [32-1:0] result_tem;
    
    assign set = src1[31] ^ ~(src2[31]) ^ carry[31-1];
    
    genvar i;
    generate 
         for (i = 0; i < 32; i=i+1)begin: mm
             alu_top aa(
                    .src1(src1[i]),
                    .src2(src2[i]),
                    .less((i ==0) ? set : 1'b0),
                    .A_invert(ALU_control[3]),
                    .B_invert(ALU_control[2]),
                    .cin((i == 0) ? ALU_control[2] & ALU_control[1]: carry[i-1]),
                    .operation(ALU_control[1:0]),
                    .result(result_tem[i]),
                    .cout(carry[i])
                    );
        end
    endgenerate
    
    always@(posedge clk or posedge rst_n) 
    begin
        if (rst_n == 1) begin
            cout = 0;
            result = 0;
            overflow = 0;
            if(ALU_control[1:0] ==2'b10) begin
                cout = carry[31];
                A = ALU_control[3] ? !src1[31]: src1[31];
                B = ALU_control[2] ? !src2[31]: src2[31];
                overflow = ((~(A^B))) & (A^result_tem[31]);
            end
            
            result = result_tem;
            zero = (result==0);
        end
    end
    
endmodule
