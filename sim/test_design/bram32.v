module top(input wire clk,
	input wire [30:0] io_in, output wire [30:0] io_out, io_oeb,
	output wire [7:0] bram0_rd_addr, bram0_wr_addr, output wire [31:0] bram0_wr_data, input wire [31:0] bram0_rd_data, output wire [7:0] bram0_config,
	output wire [7:0] bram1_rd_addr, bram1_wr_addr, output wire [31:0] bram1_wr_data, input wire [31:0] bram1_rd_data, output wire [7:0] bram1_config,
	output wire [7:0] bram2_rd_addr, bram2_wr_addr, output wire [31:0] bram2_wr_data, input wire [31:0] bram2_rd_data, output wire [7:0] bram2_config,
	output wire [7:0] bram3_rd_addr, bram3_wr_addr, output wire [31:0] bram3_wr_data, input wire [31:0] bram3_rd_data, output wire [7:0] bram3_config,
	output wire [7:0] bram4_rd_addr, bram4_wr_addr, output wire [31:0] bram4_wr_data, input wire [31:0] bram4_rd_data, output wire [7:0] bram4_config,
	output wire [7:0] bram5_rd_addr, bram5_wr_addr, output wire [31:0] bram5_wr_data, input wire [31:0] bram5_rd_data, output wire [7:0] bram5_config,
	output wire [7:0] bram6_rd_addr, bram6_wr_addr, output wire [31:0] bram6_wr_data, input wire [31:0] bram6_rd_data, output wire [7:0] bram6_config,
	output wire [7:0] bram7_rd_addr, bram7_wr_addr, output wire [31:0] bram7_wr_data, input wire [31:0] bram7_rd_data, output wire [7:0] bram7_config
);
	wire rst = io_in[0];
	reg [7:0] ctr;

	always @(posedge clk)
		if (rst)
			ctr <= 0;
		else
			ctr <= ctr + 1'b1;

	assign bram0_rd_addr = ctr - 1;
	assign bram0_wr_addr = ctr;
	assign bram0_wr_data = {4{ctr}};
	assign bram0_config = 8'b00010000; // 32-bit R/W, always write enable; 

	reg [7:0] read_reg;
	always @(posedge clk)
		read_reg <= bram0_rd_data[7:0];

	assign io_out = {ctr, read_reg, 1'b0}; // pass thru reset for debugging
	assign io_oeb = ~(28'b1);
endmodule
