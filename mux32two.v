module mux32two (i0,i1,i2,sel,out);
parameter no=32;
input [no-1:0]i0,i1;
input [no-1:0]i2;
input [1:0]sel;
output [no-1:0]out;
assign out=((sel==2'b00)?i0:(sel==2'b01)?i1:(sel==2'b10||sel==2'b11)?i2:2'bxx);
endmodule