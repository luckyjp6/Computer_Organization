// id: 109550022

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
    case (ALUOp_i)
        3'b000: ALUCtrl_o <= 4'b0010; // lw, sw, addi
        3'b001: ALUCtrl_o <= 4'b0110; // beq, bne, bge, bgt
        3'b010: ALUCtrl_o <= 4'b0111; // slti
        3'b100: begin // R-format
            case (funct_i)
                6'b100000: ALUCtrl_o <= 4'b0010; // add
                6'b100010: ALUCtrl_o <= 4'b0110; // sub
                6'b100100: ALUCtrl_o <= 4'b0000; // and
                6'b100101: ALUCtrl_o <= 4'b0001; // or
                6'b101010: ALUCtrl_o <= 4'b0111; // slt
                6'b011000: ALUCtrl_o <= 4'b0011; // mult
            endcase
        end
    endcase
end

endmodule                    
