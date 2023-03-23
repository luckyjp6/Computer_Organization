// id: 109550022

`timescale 1ns/1ps
module Hazard(
    inst_ID,
    RegRt_EX,
    MemRead_EX,
    branch,
    PC_Write,
    IF_ID_Write,
    IF_ID_Flush,
    ID_EX_Flush,
    EX_MEM_Flush
	);
     
//I/O ports
input [32-1:0] inst_ID;
input [5-1:0] RegRt_EX;
input branch, MemRead_EX;
output PC_Write, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush;

//Internal Signals
reg    PC_Write, IF_ID_Write, IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush;

//Parameter

//Main function
always @(*) begin
    
    case (branch)
        1'b1: begin // branch !!
           PC_Write <= 1'b1;
           IF_ID_Write <= 1'b1;
           IF_ID_Flush <= 1'b1;
           ID_EX_Flush <= 1'b1;
           EX_MEM_Flush <= 1'b1;
        end
        1'b0: begin // load -use hazard
            if(MemRead_EX 
            & ((RegRt_EX == inst_ID[25:21]) | (RegRt_EX == inst_ID[20:16]))) begin
                   PC_Write <= 1'b0;
                   IF_ID_Write <= 1'b0;
                   IF_ID_Flush <= 1'b0;
                   ID_EX_Flush <= 1'b1;
                   EX_MEM_Flush <= 1'b0;
            end
            else begin
               PC_Write <= 1'b1;
               IF_ID_Write <= 1'b1;
               IF_ID_Flush <= 1'b0;
               ID_EX_Flush <= 1'b0;
               EX_MEM_Flush <= 1'b0;
            end
                
        end
    endcase
end
endmodule