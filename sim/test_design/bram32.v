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

	wire [14:0] osc;
	(* BEL="X1Y1.A" *) LUT1 #(.INIT(2'b1)) l0 (.I0(osc[0]), .O(osc[1]));
	(* BEL="X1Y1.B" *) LUT1 #(.INIT(2'b1)) l1 (.I0(osc[1]), .O(osc[2]));
	(* BEL="X1Y1.C" *) LUT1 #(.INIT(2'b1)) l2 (.I0(osc[2]), .O(osc[3]));
	(* BEL="X1Y1.D" *) LUT1 #(.INIT(2'b1)) l3 (.I0(osc[3]), .O(osc[4]));
	(* BEL="X1Y1.E" *) LUT1 #(.INIT(2'b1)) l4 (.I0(osc[4]), .O(osc[5]));
	(* BEL="X1Y1.F" *) LUT1 #(.INIT(2'b1)) l5 (.I0(osc[5]), .O(osc[6]));
	(* BEL="X1Y1.G" *) LUT1 #(.INIT(2'b1)) l6 (.I0(osc[6]), .O(osc[7]));
	(* BEL="X1Y1.H" *) LUT1 #(.INIT(2'b1)) l7 (.I0(osc[7]), .O(osc[8]));
	(* BEL="X1Y2.A" *) LUT1 #(.INIT(2'b1)) l8 (.I0(osc[8]), .O(osc[9]));
	(* BEL="X1Y2.B" *) LUT1 #(.INIT(2'b1)) l9 (.I0(osc[9]), .O(osc[10]));
	(* BEL="X1Y2.C" *) LUT1 #(.INIT(2'b1)) l10 (.I0(osc[10]), .O(osc[11]));
	(* BEL="X1Y2.D" *) LUT1 #(.INIT(2'b1)) l11 (.I0(osc[11]), .O(osc[12]));
	(* BEL="X1Y2.E" *) LUT1 #(.INIT(2'b1)) l12 (.I0(osc[12]), .O(osc[13]));
	(* BEL="X1Y2.F" *) LUT1 #(.INIT(2'b1)) l13 (.I0(osc[13]), .O(osc[14]));
	(* BEL="X1Y2.G" *) LUT1 #(.INIT(2'b1)) l14 (.I0(osc[14]), .O(osc[0]));

	wire osco;
	(* BEL="X1Y2.H" *) LUT1 #(.INIT(2'b1)) lo (.I0(osc[0]), .O(osco));

	assign io_out[22:0] = {ctr, read_reg, 1'b0}; // pass thru reset for debugging
	assign io_out[23] = osco;
	assign io_oeb = ~(28'b1);
endmodule
