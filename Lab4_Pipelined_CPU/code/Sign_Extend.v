// id: 109550022

`timescale 1ns/1ps
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended

always @(data_i) begin
    data_o <= { {16{data_i[15]}}, data_i[15:0] };
end
endmodule      
     