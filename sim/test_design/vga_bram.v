module top(input wire clk, input wire [30:0] io_in, output wire [30:0] io_out, io_oeb,
	output wire [7:0] bram0_rd_addr, bram0_wr_addr, output wire [31:0] bram0_wr_data, input wire [31:0] bram0_rd_data, output wire [7:0] bram0_config,
	output wire [7:0] bram1_rd_addr, bram1_wr_addr, output wire [31:0] bram1_wr_data, input wire [31:0] bram1_rd_data, output wire [7:0] bram1_config,
	output wire [7:0] bram2_rd_addr, bram2_wr_addr, output wire [31:0] bram2_wr_data, input wire [31:0] bram2_rd_data, output wire [7:0] bram2_config,
	output wire [7:0] bram3_rd_addr, bram3_wr_addr, output wire [31:0] bram3_wr_data, input wire [31:0] bram3_rd_data, output wire [7:0] bram3_config,
	output wire [7:0] bram4_rd_addr, bram4_wr_addr, output wire [31:0] bram4_wr_data, input wire [31:0] bram4_rd_data, output wire [7:0] bram4_config,
	output wire [7:0] bram5_rd_addr, bram5_wr_addr, output wire [31:0] bram5_wr_data, input wire [31:0] bram5_rd_data, output wire [7:0] bram5_config,
	output wire [7:0] bram6_rd_addr, bram6_wr_addr, output wire [31:0] bram6_wr_data, input wire [31:0] bram6_rd_data, output wire [7:0] bram6_config,
	output wire [7:0] bram7_rd_addr, bram7_wr_addr, output wire [31:0] bram7_wr_data, input wire [31:0] bram7_rd_data, output wire [7:0] bram7_config
);
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

	wire [3:0] read_data;

	reg r, g, b;
	always @(posedge clk) begin
		if (vcnt <= 256 && (hcnt >= 64 && hcnt <= 192))
			{r, g, b} <= read_data[2:0];
		else
			{r, g, b} <= 3'b000;
	end

	wire [13:0] read_address = {vcnt[7:1], hcnt[6:0] ^ 7'b1000000};

	assign io_out[5:1] = {b, g, r, vsync, hsync};
	assign io_out[30:6] = 0;
	assign io_out[0] = 1'b0;

	wire reset = io_in[0];
	wire serial_clk = io_in[6];
	wire serial_data = io_in[7];

	reg [12:0] write_address, write_address_cnt;
	reg [7:0] write_sr;
	reg [7:0] write_strobe, write_strobe_reg;
	reg [2:0] write_bit;

	assign {bram0_rd_addr, bram1_rd_addr, bram2_rd_addr, bram3_rd_addr, bram4_rd_addr, bram5_rd_addr, bram6_rd_addr, bram7_rd_addr} = {8{read_address[8:1]}};
	assign {bram0_wr_addr, bram1_wr_addr, bram2_wr_addr, bram3_wr_addr, bram4_wr_addr, bram5_wr_addr, bram6_wr_addr, bram7_wr_addr} = {8{write_address[7:0]}};

	assign {bram0_wr_data[7:0], bram1_wr_data[7:0], bram2_wr_data[7:0], bram3_wr_data[7:0], bram4_wr_data[7:0], bram5_wr_data[7:0], bram6_wr_data[7:0], bram7_wr_data[7:0]} = {8{write_sr[7:0]}};

	assign {bram7_wr_data[20], bram6_wr_data[20], bram5_wr_data[20], bram4_wr_data[20], bram3_wr_data[20], bram2_wr_data[20], bram1_wr_data[20], bram0_wr_data[20]} = write_strobe_reg;
	assign {bram7_wr_data[25:24], bram6_wr_data[25:24], bram5_wr_data[25:24], bram4_wr_data[25:24], bram3_wr_data[25:24], bram2_wr_data[25:24], bram1_wr_data[25:24], bram0_wr_data[25:24]} = {8{read_address[10:9]}};
	assign {bram7_wr_data[17:16], bram6_wr_data[17:16], bram5_wr_data[17:16], bram4_wr_data[17:16], bram3_wr_data[17:16], bram2_wr_data[17:16], bram1_wr_data[17:16], bram0_wr_data[17:16]} = {8{write_address[9:8]}};

	assign {bram0_config, bram1_config, bram2_config, bram3_config, bram4_config, bram5_config, bram6_config, bram7_config} = {8{8'b00100101}};


	wire [63:0] bram_rd_data = {bram7_rd_data[7:0], bram6_rd_data[7:0], bram5_rd_data[7:0], bram4_rd_data[7:0], bram3_rd_data[7:0], bram2_rd_data[7:0], bram1_rd_data[7:0], bram0_rd_data[7:0]};
	reg [13:0] read_address_delay;
	always @(posedge clk)
		read_address_delay <= read_address;

	assign read_data = bram_rd_data[(8*read_address_delay[13:11] + 4*read_address_delay[0]) +: 4];

	reg [2:0] wclk_samp, wdat_samp;
	always @(posedge clk) begin
		if (reset) begin
			write_strobe <= 8'b0;
			write_address_cnt <= 13'b0;
			write_bit <= 3'b0;
			wclk_samp <= 3'b0;
		end else begin
			write_strobe <= 8'b0;
			wclk_samp <= {wclk_samp[1:0], serial_clk};
			wdat_samp <= {wdat_samp[1:0], serial_data};
			if (wclk_samp[2] ^ wclk_samp[1]) begin
				write_sr <= {write_sr[6:0], wdat_samp[2]};
				if (write_bit == 7) begin
					write_strobe[write_address_cnt[12:10]] <= 1'b1;
					write_address_cnt <= write_address_cnt + 1'b1;
					write_bit <= 0;
				end else begin
					write_bit <= write_bit + 1'b1;
				end
			end
		end
		write_address <= write_address_cnt;
		write_strobe_reg <= write_strobe;
	end

	assign io_oeb = ~(30'b11000001);

endmodule
