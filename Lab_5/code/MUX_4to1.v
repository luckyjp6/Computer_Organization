//id: 109550022
`timescale 1ns / 1ps

module MUX_4to1(
    data0_i,
    data1_i,
    data2_i,
    data3_i,
    branch_type,
    branch
    );

parameter size = 0;

input [size-1:0] data0_i, data1_i, data2_i, data3_i;
input [2-1:0] branch_type;
output branch;

reg branch;

always @(*) begin
    case (branch_type)
    0: branch <= data0_i;
    1: branch <= data1_i;
    2: branch <= data2_i;
    3: branch <= data3_i;
    
    endcase
end
    
endmodule
