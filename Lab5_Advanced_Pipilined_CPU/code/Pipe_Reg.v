// id: 109550022

`timescale 1ns / 1ps
module Pipe_Reg(
    clk_i,
    rst_i,
    pipe_reg_write,
    flush,
    data_i,    
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   pipe_reg_write, flush;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    
    if(~rst_i | flush) data_o <= 0;
    else begin
        if (pipe_reg_write)
            data_o <= data_i;
        else
            data_o <= data_o;
    end 
end

endmodule	