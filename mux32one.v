module mux32one(i0,i1,sel,out);
parameter no=32;
input [no-1:0]i0,i1;
input sel;
output reg [no-1:0]out;

assign out=i0;
endmodule