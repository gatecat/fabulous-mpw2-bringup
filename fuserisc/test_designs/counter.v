module top(input wire clk, input wire [9:0] io_in, output wire [9:0] io_out, io_oeb);
	reg [23:0] ctr;

	always @(posedge clk)
		ctr <= ctr + 1'b1;

	assign io_out = ctr[23:14];
	assign io_oeb = 10'h3FF;
endmodule
