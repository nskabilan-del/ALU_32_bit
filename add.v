module add(i0,i1,sum);
parameter no=32;
input [no-1:0]i0,i1;
output [no-1:0]sum;
assign sum=i0+i1;
endmodule