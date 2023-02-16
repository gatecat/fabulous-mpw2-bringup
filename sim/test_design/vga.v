module top(input wire clk, input wire [30:0] io_in, output wire [30:0] io_out, io_oeb,
	output wire [7:0] bram0_rd_addr, bram0_wr_addr, output wire [31:0] bram0_wr_data, input wire [31:0] bram0_rd_data, output wire [7:0] bram0_config,
	output wire [7:0] bram1_rd_addr, bram1_wr_addr, output wire [31:0] bram1_wr_data, input wire [31:0] bram1_rd_data, output wire [7:0] bram1_config,
	output wire [7:0] bram2_rd_addr, bram2_wr_addr, output wire [31:0] bram2_wr_data, input wire [31:0] bram2_rd_data, output wire [7:0] bram2_config,
	output wire [7:0] bram3_rd_addr, bram3_wr_addr, output wire [31:0] bram3_wr_data, input wire [31:0] bram3_rd_data, output wire [7:0] bram3_config,
	output wire [7:0] bram4_rd_addr, bram4_wr_addr, output wire [31:0] bram4_wr_data, input wire [31:0] bram4_rd_data, output wire [7:0] bram4_config,
	output wire [7:0] bram5_rd_addr, bram5_wr_addr, output wire [31:0] bram5_wr_data, input wire [31:0] bram5_rd_data, output wire [7:0] bram5_config,
	output wire [7:0] bram6_rd_addr, bram6_wr_addr, output wire [31:0] bram6_wr_data, input wire [31:0] bram6_rd_data, output wire [7:0] bram6_config,
	output wire [7:0] bram7_rd_addr, bram7_wr_addr, output wire [31:0] bram7_wr_data, input wire [31:0] bram7_rd_data, output wire [7:0] bram7_config);
	// running at 10MHz: divide horizontal timings by 2.5
	localparam HVIS = 256;
	localparam HFP = HVIS+6;
	localparam HS = HFP+39;
	localparam HT = 320;

	localparam VVIS = 480;
	localparam VFP = VVIS+10;
	localparam VS = VFP+2;
	localparam VT = 525;

	reg [9:0] hcnt, vcnt;
	reg visible;
	reg hsync, vsync;

	always @(posedge clk) begin
		if (hcnt == (HT - 1)) begin
			if (vcnt == (VT - 1)) begin
				vcnt <= 0;
			end else begin
				vcnt <= vcnt + 1'b1;
			end
			hcnt <= 0;
		end else begin
			hcnt <= hcnt + 1'b1;
		end
		hsync <= ~((hcnt >= HFP) && (hcnt < HS));
		vsync <= ~((vcnt >= VFP) && (vcnt < VS));
		visible <= (hcnt < HVIS) && (vcnt < VVIS);
	end 

	reg [2:0] image[0:32*32-1];
	initial $readmemh("out.hex", image);

	reg r, g, b;
	always @(posedge clk) begin
		if (vcnt <= 256 && (hcnt >= 64 && hcnt <= 192))
			{r, g, b} <= image[{vcnt[7:3], hcnt[6:2] ^ 5'b10000}];
		else
			{r, g, b} <= 3'b000;
	end

	assign io_out[5:1] = {b, g, r, vsync, hsync};
	assign io_out[30:6] = 0;
	assign io_out[0] = 1'b0;

	assign io_oeb = ~(30'b1);

endmodule
