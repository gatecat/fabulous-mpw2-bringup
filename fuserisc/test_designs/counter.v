module top(input wire clk, input wire [9:0] io_in, output wire [9:0] io_out, io_oeb);
	reg [23:0] ctr;
	wire rst = io_in[0];

	always @(posedge clk)
		if (rst)
			ctr <= 8'b0;
		else
			ctr <= ctr + 1'b1;

	assign io_out = ctr[9:0];
	assign io_oeb = 10'h3FE;
endmodule
