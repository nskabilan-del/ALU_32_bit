`include "mux32one.v"
`include "add.v"
`include "sub.v"
`include "mul.v"
`include "mux32two.v"
module alu32(a,b,f,r);
parameter no=32;
input [no-1:0]a,b;
input [1:0]f;
output [no-1:0]r;
wire [no-1:0]ain;
wire [no-1:0]bin;
wire [no-1:0]add;
wire [no-1:0]sub;
wire [no-1:0]mul;

mux32one m1(.i0(b),.i1(32'd1),.sel(f[0]),.out(ain));
mux32one m2(.i0(b),.i1(32'd1),.sel(f[0]),.out(bin));
add m4(.i0(a),.i1(ain),.sum(add));
sub m5(.i0(a),.i1(bin),.diff(sub));
mul m6(.i0(a),.i1(b),.prod(mul));
mux32two m3(.i0(add),.i1(sub),.i2(mul),.sel(f),.out(r));
endmodule
