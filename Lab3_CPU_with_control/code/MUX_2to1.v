// id: 109550022

`timescale 1ns/1ps
module MUX_2to1(
               data0_i,
               data1_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always @(data0_i or data1_i or select_i) begin
    data_o <= select_i ? data1_i:data0_i;
end

endmodule      
          
          