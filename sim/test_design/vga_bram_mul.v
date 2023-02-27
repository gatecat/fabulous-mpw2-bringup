module top(input wire clk, input wire [30:0] io_in, output wire [30:0] io_out, io_oeb);
	// running at 10MHz: divide horizontal timings by 2.5
	// Video timing generation
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

	// Perspective transformation
	wire [3:0] road_rdata;

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

	assign y_scale = x_scale / 4;

	wire [15:0] x0, x1;
	dsp_mul mulx0_i (.A({1'b0, x_adj}), .B(x_scale[7:0]), .Q(x0));
	dsp_mul mulx1_i (.A({1'b0, x_adj}), .B(x_scale[15:8]), .Q(x1));

	wire [22:0] x_out = x0 + (x1 << 8);

	wire [15:0] y0, y1;
	dsp_mul muly0_i (.A({1'b0, y_adj}), .B(y_scale[7:0]), .Q(y0));
	dsp_mul muly1_i (.A({1'b0, y_adj}), .B(y_scale[15:8]), .Q(y1));
	wire [22:0] y_out = y0 + (y1 << 8);

	reg [1:0] r, g, b;

	reg [6:0] x_addr;
	reg [5:0] y_addr;
	reg x_vis;

	localparam x_shift = 16, y_shift = 16;

	// Output generation
	always @(posedge clk) begin
		x_vis <= (x_out[22:x_shift+1] == 0) && (y_out[22:y_shift+1] == 0);
		x_addr[6] <= x_sign;
		x_addr[5:0] <= x_sign ? x_out[x_shift:x_shift-5] : (63 - x_out[x_shift:x_shift-5]);
		y_addr[5:0] <= y_out[y_shift:y_shift-5] + frame_cnt;
		if (!hcnt[8] && x_vis)
			{r, g, b} <= {road_rdata[2] & road_rdata[3], road_rdata[2], // 4bit -> 6bit
				          road_rdata[1] & road_rdata[3], road_rdata[1],
				          road_rdata[0] & road_rdata[3], road_rdata[0]};
		else
			{r, g, b} <= 6'b0;
	end

	wire [12:0] road_raddr = {y_addr, x_addr};

	assign io_out[5:1] = {b[1], g[1], r[1], vsync, hsync};

	// assign io_out[30:6] = 0;
	assign io_out[0] = 1'b0;

	wire reset = io_in[0];
	wire write_clock = io_in[6];
	wire write_data  = io_in[7];

	assign io_out[10:8] = {b[0], g[0], r[0]};

	assign io_oeb = ~(30'b11000001);

	// Video memory

	texture_mem mem_i (
		.clk(clk),
		.write_rst(reset), .write_clock(write_clock), .write_data(write_data),
		.bank0_raddr(road_raddr),
		.bank0_rdata(road_rdata),
		.bank1_raddr()
	);

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

module texture_mem (
	input clk,
	input write_rst, write_data, write_clock,
	input [12:0] bank0_raddr,
	output [3:0] bank0_rdata,
	input [12:0] bank1_raddr,
	output [3:0] bank1_rdata,
);
	reg [12:0] write_address;
	reg [7:0] write_sr;
	reg [7:0] write_strobe;
	reg [2:0] write_bit;

	reg [12:0] raddr0_delay, raddr1_delay;
	always @(posedge clk) begin
		raddr0_delay <= bank0_raddr;
		raddr1_delay <= bank1_raddr;
	end

	wire [63:0] bram_rdata;
	assign bank0_rdata = bram_rdata[(8*raddr0_delay[12:11] + 4*raddr0_delay[0]) +: 4];
	assign bank1_rdata = bram_rdata[(32 + 8*raddr1_delay[12:11] + 4*raddr1_delay[0]) +: 4];

	reg [2:0] wclk_samp, wdat_samp;
	reg [2:0] write_state;
	reg write_go;

	always @(posedge clk) begin
		if (write_rst) begin
			write_bit <= 3'b0;
			wclk_samp <= 3'b0;
			write_go <= 1'b0;
		end else begin
			wclk_samp <= {wclk_samp[1:0], write_clock};
			wdat_samp <= {wdat_samp[1:0], write_data};
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
		if (write_rst) begin
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

	generate
	genvar i;
	for (i = 0; i < 8; i=i+1'b1) begin: ram_array
		wire [31:0] rdata;
		bram #(.LOC(i), .IN_REG(1'b0), .OUT_REG(1'b0)) bram_i (
			.clk(clk),
			.waddr(write_address[7:0]), .raddr((i >= 4) ? bank1_raddr[8:1] : bank0_raddr[8:1]),
			.cfg(8'b00100101),
			.wdata({6'b0, ((i >= 4) ? bank1_raddr[10:9] : bank0_raddr[10:9]),
				         3'b0, write_strobe[i], 2'b0, write_address[9:8], 8'b0, write_sr}),
			.rdata(rdata)
		);
		assign bram_rdata[8*i+:8] = rdata[7:0];
	end
	endgenerate

endmodule

module bram	#(
		parameter LOC = 0,
		parameter IN_REG = 1'b0,
		parameter OUT_REG = 1'b0,
		localparam DEV_HEIGHT = 16,
		localparam BRAM_X = 10,
	) (
		input clk,
		input [7:0] waddr, raddr, cfg,
		input [31:0] wdata,
		output [31:0] rdata
	);

	localparam x = BRAM_X;
	localparam y0 = (DEV_HEIGHT - 2*LOC);

(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_A1", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op0_i (.CLK(clk), .I3(raddr[0]), .I2(raddr[1]), .I1(raddr[2]), .I0(raddr[3]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_A0", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op1_i (.CLK(clk), .I3(raddr[4]), .I2(raddr[5]), .I1(raddr[6]), .I0(raddr[7]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_A1", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op2_i (.CLK(clk), .I3(waddr[0]), .I2(waddr[1]), .I1(waddr[2]), .I0(waddr[3]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_A0", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op3_i (.CLK(clk), .I3(waddr[4]), .I2(waddr[5]), .I1(waddr[6]), .I0(waddr[7]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D3", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op4_i (.CLK(clk), .I3(wdata[0]), .I2(wdata[1]), .I1(wdata[2]), .I0(wdata[3]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D3", x, y0) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip5_i (.CLK(clk), .O3(rdata[0]), .O2(rdata[1]), .O1(rdata[2]), .O0(rdata[3]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D2", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op6_i (.CLK(clk), .I3(wdata[4]), .I2(wdata[5]), .I1(wdata[6]), .I0(wdata[7]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D2", x, y0) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip7_i (.CLK(clk), .O3(rdata[4]), .O2(rdata[5]), .O1(rdata[6]), .O0(rdata[7]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D1", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op8_i (.CLK(clk), .I3(wdata[8]), .I2(wdata[9]), .I1(wdata[10]), .I0(wdata[11]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D1", x, y0) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip9_i (.CLK(clk), .O3(rdata[8]), .O2(rdata[9]), .O1(rdata[10]), .O0(rdata[11]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D0", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op10_i (.CLK(clk), .I3(wdata[12]), .I2(wdata[13]), .I1(wdata[14]), .I0(wdata[15]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D0", x, y0) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip11_i (.CLK(clk), .O3(rdata[12]), .O2(rdata[13]), .O1(rdata[14]), .O0(rdata[15]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D3", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op12_i (.CLK(clk), .I3(wdata[16]), .I2(wdata[17]), .I1(wdata[18]), .I0(wdata[19]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D3", x, y0-1) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip13_i (.CLK(clk), .O3(rdata[16]), .O2(rdata[17]), .O1(rdata[18]), .O0(rdata[19]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D2", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op14_i (.CLK(clk), .I3(wdata[20]), .I2(wdata[21]), .I1(wdata[22]), .I0(wdata[23]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D2", x, y0-1) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip15_i (.CLK(clk), .O3(rdata[20]), .O2(rdata[21]), .O1(rdata[22]), .O0(rdata[23]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D1", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op16_i (.CLK(clk), .I3(wdata[24]), .I2(wdata[25]), .I1(wdata[26]), .I0(wdata[27]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D1", x, y0-1) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip17_i (.CLK(clk), .O3(rdata[24]), .O2(rdata[25]), .O1(rdata[26]), .O0(rdata[27]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_D0", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op18_i (.CLK(clk), .I3(wdata[28]), .I2(wdata[29]), .I1(wdata[30]), .I0(wdata[31]));
(* keep, BEL=$sformatf("X%dY%d.RAM2FAB_D0", x, y0-1) *) InPass4_frame_config #(.I_reg({4{IN_REG}})) ip19_i (.CLK(clk), .O3(rdata[28]), .O2(rdata[29]), .O1(rdata[30]), .O0(rdata[31]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_C", x, y0) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op20_i (.CLK(clk), .I3(cfg[0]), .I2(cfg[1]), .I1(cfg[2]), .I0(cfg[3]));
(* keep, BEL=$sformatf("X%dY%d.FAB2RAM_C", x, y0-1) *) OutPass4_frame_config #(.I_reg({4{OUT_REG}})) op21_i (.CLK(clk), .I3(cfg[4]), .I2(cfg[5]), .I1(cfg[6]), .I0(cfg[7]));

endmodule
