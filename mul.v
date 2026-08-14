module mul(i0,i1,prod);
parameter no=32;
input [no-1:0]i0,i1;
output [no-1:0]prod;
assign prod=i0*i1;
endmodule