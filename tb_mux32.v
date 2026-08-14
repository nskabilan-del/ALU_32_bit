`include "alu32.v"
module tb_mux32;
parameter no=32;
reg [no-1:0]a,b;
reg [1:0]f;
wire [no-1:0]r;
alu32 dut (a,b,f,r);
initial begin
repeat(20)begin
a=$random;
b=$random;
f=$random;
#1;
$display("a=%0h,b=%0h,f=%b,r=%0h",a,b,f,r);

end
end
endmodule

