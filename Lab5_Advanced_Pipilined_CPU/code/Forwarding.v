// id: 109550022

`timescale 1ns/1ps
module Forwarding(
    RegRd_MEM,
    RegRd_WB,
    RegWrite_MEM,
    RegWrite_WB,
    RegRs_EX,
    RegRt_EX,
    ALU_src1_select,
    ALU_src2_select
	);
     
//I/O ports
input  [5-1:0]  RegRd_MEM, RegRd_WB, RegRs_EX, RegRt_EX;
input  RegWrite_MEM, RegWrite_WB;
output [2-1:0]	 ALU_src1_select, ALU_src2_select;

assign ALU_src1_select = { RegWrite_MEM & (|RegRd_MEM) & (RegRd_MEM == RegRs_EX),
                        RegWrite_WB & (|RegRd_WB) & (RegRd_WB == RegRs_EX)};
assign ALU_src2_select = { RegWrite_MEM & (|RegRd_MEM) & (RegRd_MEM == RegRt_EX),
                        RegWrite_WB & (|RegRd_WB) & (RegRd_WB == RegRt_EX)};

/*always @(*) begin
    
    if (RegWrite_MEM & (|RegRd_MEM) & (RegRd_MEM == RegRs_EX)) 
        ALU_src1_select <= 2'b01;
    else if (RegWrite_WB & (|RegRd_WB) & (RegRd_WB == RegRs_EX))
        ALU_src1_select <= 2'b10;
    else
        ALU_src1_select <= 2'b00;
        
    if (RegWrite_MEM & (|RegRd_MEM) & (RegRd_MEM == RegRt_EX))
        ALU_src2_select <= 2'b01;
    else if (RegWrite_WB & (|RegRd_WB) & (RegRd_WB == RegRt_EX)) 
        ALU_src2_select <= 2'b10;
    else
        ALU_src2_select <= 2'b00;

end*/

endmodule