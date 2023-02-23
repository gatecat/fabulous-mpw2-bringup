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

	reg [8:0] hcnt;
	reg [9:0] vcnt;
	reg visible;
	reg hsync, vsync;
	reg [3:0] hsync_pipe, vsync_pipe;

	reg [6:0] frame_cnt;

	always @(posedge clk) begin
		if (hcnt >= (HT - 1)) begin
			if (vcnt >= (VT - 1)) begin
				frame_cnt <= frame_cnt + 1'b1;
				vcnt <= 0;
			end else begin
				vcnt <= vcnt + 1'b1;
			end
			hcnt <= 0;
		end else begin
			hcnt <= hcnt + 1'b1;
		end
		{hsync, hsync_pipe} <= {hsync_pipe, ~((hcnt >= HFP) && (hcnt < HS))};
		{vsync, vsync_pipe} <= {vsync_pipe, ~((vcnt >= VFP) && (vcnt < VS))};
		visible <= (hcnt < HVIS) && (vcnt < VVIS);
	end 

	wire [3:0] read_data;

	reg x_sign;
	reg [6:0] x_adj;
	reg [6:0] y_adj;
	reg [9:0] vcnt_next;


	always @(posedge clk) begin
		x_sign <= hcnt[7];
		x_adj <= hcnt[7] ? hcnt[6:0] :  (127 - hcnt[6:0]);
		y_adj <= (127 - vcnt[8:2]);
		vcnt_next <= vcnt + 1'b1;
	end

	wire [15:0] x_scale, y_scale;

	divider x_div(.clk(clk), .start(hcnt == 256), .a(255*256), .b(vcnt_next[8:2]), .q(x_scale[15:0]));
    divider y_div(.clk(clk), .start(hcnt == 256), .a(63*256), .b(vcnt_next[8:2]), .q(y_scale[15:0]));

	// assign y_scale = x_scale / 4;

	wire [15:0] x0, x1;
	dsp_mul mulx0_i (.A({1'b0, x_adj}), .B(x_scale[7:0]), .Q(x0));
	dsp_mul mulx1_i (.A({1'b0, x_adj}), .B(x_scale[15:8]), .Q(x1));

	wire [22:0] x_out = x0 + (x1 << 8);

	wire [15:0] y0, y1;
	dsp_mul muly0_i (.A({1'b0, y_adj}), .B(y_scale[7:0]), .Q(y0));
	dsp_mul muly1_i (.A({1'b0, y_adj}), .B(y_scale[15:8]), .Q(y1));
	wire [22:0] y_out = y0 + (y1 << 8);

	reg r, g, b;

	reg [6:0] x_addr, y_addr;
	reg x_vis;

	localparam x_shift = 16, y_shift = 16;

	always @(posedge clk) begin
		x_vis <= (x_out[22:x_shift+1] == 0) && (y_out[22:y_shift+1] == 0);
		x_addr[6] <= x_sign;
		x_addr[5:0] <= x_sign ? x_out[x_shift:x_shift-5] : (63 - x_out[x_shift:x_shift-5]);
		y_addr[6] <= 1'b0;
		y_addr[5:0] <= y_out[y_shift:y_shift-5] + frame_cnt;
		if (!hcnt[8] && x_vis)
			{r, g, b} <= read_data[2:0];
		else
			{r, g, b} <= 3'b000;
	end

	wire [13:0] read_address = {y_addr, x_addr};

	assign io_out[5:1] = {b, g, r, vsync, hsync};
	// assign io_out[30:6] = 0;
	assign io_out[23] = write_go;
	assign io_out[0] = 1'b0;

	wire reset = io_in[0];
	wire serial_clk = io_in[6];
	wire serial_data = io_in[7];

	reg [12:0] write_address;
	reg [7:0] write_sr;
	reg [7:0] write_strobe;
	reg [2:0] write_bit;

	assign {bram0_rd_addr, bram1_rd_addr, bram2_rd_addr, bram3_rd_addr, bram4_rd_addr, bram5_rd_addr, bram6_rd_addr, bram7_rd_addr} = {8{read_address[8:1]}};
	assign {bram0_wr_addr, bram1_wr_addr, bram2_wr_addr, bram3_wr_addr, bram4_wr_addr, bram5_wr_addr, bram6_wr_addr, bram7_wr_addr} = {8{write_address[7:0]}};

	assign {bram0_wr_data[7:0], bram1_wr_data[7:0], bram2_wr_data[7:0], bram3_wr_data[7:0], bram4_wr_data[7:0], bram5_wr_data[7:0], bram6_wr_data[7:0], bram7_wr_data[7:0]} = {8{write_sr[7:0]}};

	assign {bram4_wr_data[20], bram7_wr_data[20], bram6_wr_data[20], bram5_wr_data[20], bram3_wr_data[20], bram2_wr_data[20], bram1_wr_data[20], bram0_wr_data[20]} = write_strobe;
	assign {bram7_wr_data[25:24], bram6_wr_data[25:24], bram5_wr_data[25:24], bram4_wr_data[25:24], bram3_wr_data[25:24], bram2_wr_data[25:24], bram1_wr_data[25:24], bram0_wr_data[25:24]} = {8{read_address[10:9]}};
	assign {bram7_wr_data[17:16], bram6_wr_data[17:16], bram5_wr_data[17:16], bram4_wr_data[17:16], bram3_wr_data[17:16], bram2_wr_data[17:16], bram1_wr_data[17:16], bram0_wr_data[17:16]} = {8{write_address[9:8]}};

	assign {bram0_config, bram1_config, bram2_config, bram3_config, bram4_config, bram5_config, bram6_config, bram7_config} = {8{8'b00100101}};


	wire [63:0] bram_rd_data = {bram4_rd_data[7:0], bram7_rd_data[7:0], bram6_rd_data[7:0], bram5_rd_data[7:0], bram3_rd_data[7:0], bram2_rd_data[7:0], bram1_rd_data[7:0], bram0_rd_data[7:0]};
	reg [13:0] read_address_delay;
	always @(posedge clk)
		read_address_delay <= read_address;

	assign read_data = bram_rd_data[(8*read_address_delay[13:11] + 4*read_address_delay[0]) +: 4];

	reg [2:0] wclk_samp, wdat_samp;
	reg [2:0] write_state;
	reg write_go;
	always @(posedge clk) begin
		if (reset) begin
			write_bit <= 3'b0;
			wclk_samp <= 3'b0;
			write_go <= 1'b0;
		end else begin
			wclk_samp <= {wclk_samp[1:0], serial_clk};
			wdat_samp <= {wdat_samp[1:0], serial_data};
			write_go <= 1'b0;
			if (wclk_samp[2] ^ wclk_samp[1]) begin
				write_sr[7-write_bit] <= {write_sr[6:0], wdat_samp[2]};
				if (write_bit == 7) begin
					write_go <= 1'b1;
					write_bit <= 0;
				end else begin
					write_bit <= write_bit + 1'b1;
				end
			end
		end
	end

	always @(posedge clk) begin
		if (reset) begin
			write_state <= 3'b000;
			write_strobe <= 8'b0;
			write_address <= 12'b0;
		end else begin
			case (write_state)
				3'b000: begin
					if (write_go) write_state <= 3'b001;
					write_strobe <= 8'b0;
				end
				3'b001: begin
					write_strobe[write_address[12:10]] <= 1'b1;
					write_state <= 3'b010;
				end
				3'b010: begin
					write_state <= 3'b011;
				end
				3'b011: begin
					write_strobe <= 8'b0;
					write_state <= 3'b100;
				end
				3'b100: begin
					write_state <= 3'b101;
				end
				3'b101: begin
					write_address <= write_address + 1'b1;
					write_state <= 3'b000;
				end
				default: write_state <= 3'b000;
			endcase
		end
	end

	assign io_oeb = ~(30'b11000001);

endmodule

module dsp_mul(
	input [7:0] A, B,
	output [15:0] Q
);

	wire [19:0] C = 20'b0;

	MULADD #(
		.A_reg(1'b0),
		.B_reg(1'b0),
		.C_reg(1'b0),
		.ACC(1'b0),
		.signExtension(1'b0),
		.ACCout(1'b0)
	) mul (
		.A0(A[0]), .A1(A[1]), .A2(A[2]), .A3(A[3]), .A4(A[4]), .A5(A[5]), .A6(A[6]), .A7(A[7]),
		.B0(B[0]), .B1(B[1]), .B2(B[2]), .B3(B[3]), .B4(B[4]), .B5(B[5]), .B6(B[6]), .B7(B[7]),
		.C0(C[0]), .C1(C[1]), .C2(C[2]), .C3(C[3]), .C4(C[4]), .C5(C[5]), .C6(C[6]), .C7(C[7]), .C8(C[8]), .C9(C[9]), .C10(C[10]), .C11(C[11]), .C12(C[12]), .C13(C[13]), .C14(C[14]), .C15(C[15]), .C16(C[16]), .C17(C[17]), .C18(C[18]), .C19(C[19]),
		.Q0(Q[0]), .Q1(Q[1]), .Q2(Q[2]), .Q3(Q[3]), .Q4(Q[4]), .Q5(Q[5]), .Q6(Q[6]), .Q7(Q[7]), .Q8(Q[8]), .Q9(Q[9]), .Q10(Q[10]), .Q11(Q[11]), .Q12(Q[12]), .Q13(Q[13]), .Q14(Q[14]), .Q15(Q[15]), 
	);
endmodule

module divider(
	input clk, start,
	input [15:0] a,
	input [15:0] b,
	output reg [15:0] q
);
	// based on picorv32
	reg [15:0] quotient, dividend, quotient_msk;
	reg [30:0] divisor;
	reg running;
	always @(posedge clk) begin
		if (start) begin
			running <= 1'b1;
			dividend <= a;
			divisor <= b << 14;
			quotient <= 0;
			quotient_msk <= (1 << 14);
			if (b == 0) begin
				q <= 16'hffff;
				running <= 1'b0;
			end
		end else if (!quotient_msk && running) begin
			running <= 1'b0;
			q <= quotient;
		end else begin
			if (divisor <= dividend) begin
				dividend <= dividend - divisor;
				quotient <= quotient | quotient_msk;
			end
			divisor <= divisor >> 1;
			quotient_msk <= quotient_msk >> 1;
		end
	end
endmodule