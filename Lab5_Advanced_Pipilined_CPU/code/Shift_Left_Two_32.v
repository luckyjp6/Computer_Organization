// id: 109550022

`timescale 1ns/1ps
module Shift_Left_Two_32(
    data_i,
    data_o
    );

//I/O ports                    
input [32-1:0] data_i;
output reg [32-1:0] data_o;

//shift left 2
always @(data_i) begin
    data_o <= {data_i[29:0], 2'b00};
end 

endmodule
