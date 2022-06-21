// id: 109550022

//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(ALUOp_i or funct_i) begin
    ALUCtrl_o[3] <= 0;
    ALUCtrl_o[2] <= (ALUOp_i == 0) | (ALUOp_i[0]) | (ALUOp_i[2] & funct_i[1]);
    ALUCtrl_o[1] <= ~(ALUOp_i[2] & funct_i[2]);
    ALUCtrl_o[0] <= (ALUOp_i == 0) | (ALUOp_i[2] & funct_i[0]) | (ALUOp_i[2] & funct_i[3]);

    // case (ALUOp_i)
    //     // R-type
    //     3'b100: case (funct_i)
    //         6'b100000: ALUCtrl_o <= 2; // add
    //         6'b100010: ALUCtrl_o <= 6; // sub
    //         6'b100100: ALUCtrl_o <= 0; // and
    //         6'b100101: ALUCtrl_o <= 1; // or
    //         6'b101010: ALUCtrl_o <= 7; // slt
    //         default: ALUCtrl_o <= 4'bxxxx;
            
    //     endcase
    //     // addi
    //     3'b010: ALUCtrl_o <= 2;
    //     // beq
    //     3'b001: ALUCtrl_o <= 6;
    //     // slt
    //     3'b000: ALUCtrl_o <= 7;
    //     default: ALUCtrl_o <= 0;
    // endcase
end

endmodule                    