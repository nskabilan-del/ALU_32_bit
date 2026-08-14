module sub(i0,i1,diff);
parameter no=32;
input [no-1:0]i0,i1;
output [no-1:0]diff;
assign diff=i0-i1;
endmodule