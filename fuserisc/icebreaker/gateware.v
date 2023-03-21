`default_nettype none
module top(
	input CLK,
	input RX,
	output TX,
	input BTN_N,
	output LEDR_N,
	output LEDG_N,

	output FLASH_SCK,
	output FLASH_SSB,
	output FLASH_IO0,
	input FLASH_IO1,

	output FLASH_IO2,
	output FLASH_IO3,

	input  P1A1, // SCLK
	input  P1A2, // GPIO
	output  P1A3, // D1
	input P1A4, // D0
	input P1A7, // CSB
	output P1A8, // XCLK
	output P1A9 // RSTN
);
	// clock divider
	reg [2:0] divclk;
	always @(posedge CLK) divclk <= divclk + 1'b1;
	assign P1A8 = divclk[2];
	// flash bridge
	flash_mitm bridge_i (
		.sys_clk(CLK),
		.sys_rstn(BTN_N),
		.cpu_rstn(P1A9),

		.cpu_sclk(P1A1),
		.cpu_csb(P1A7),
		.cpu_d0(P1A4),
		.cpu_d1(P1A3),
		.flash_sclk(FLASH_SCK),
		.flash_csb(FLASH_SSB),
		.flash_d0(FLASH_IO0),
		.flash_d1(FLASH_IO1)
	);
	// monitor LEDs
	assign LEDR_N = P1A7;
	assign LEDG_N = ~P1A2;
	assign FLASH_IO2 = 1'b1;
	assign FLASH_IO3 = 1'b1;
endmodule

// Flash MITM
// The bitstream is located at 0x00000000 which is also where caravel expects boot code...
// Resolve this by tampering with the flash enough to set bit 20, shifting everything up a MB

// Also manage the flash power-on

module flash_mitm (
	input sys_clk,
	input sys_rstn,
	output reg cpu_rstn,

	input cpu_sclk,
	input cpu_csb,
	input cpu_d0,
	output reg cpu_d1,

	output reg flash_sclk,
	output reg flash_csb,
	output reg flash_d0,
	input flash_d1
);

	// pup (power-up) state machine to send the 0xAB to ensure flash is awakened
	reg pup = 1'b0, pup_clk, pup_csb = 1'b1, pup_d0;

	localparam [7:0] pup_cmd = 8'hAB;
	reg [2:0] pup_bit = 0;
	reg [2:0] pup_state = 3'b0;

	always @(posedge sys_clk) begin
		if (!sys_rstn) begin
			pup_state <= 3'b0;
			pup_csb <= 1'b1;
			cpu_rstn <= 1'b0;
			pup_clk <= 1'b0;
			pup_bit <= 3'b0;
		end else begin
			case (pup_state)
				3'b000: begin
					pup <= 1'b1;
					pup_csb <= 1'b0;
					pup_state <= 4'b001;
				end
				3'b001: pup_state <= 4'b010;
				3'b010: begin
					pup_d0 <= pup_cmd[7-pup_bit];
					pup_state <= 4'b011;
				end
				3'b011: begin
					pup_clk <= 1'b1;
					pup_state <= 4'b100;
				end
				3'b100: begin
					pup_clk <= 1'b0;
					if (pup_bit == 7)
						pup_state <= 3'b101;
					else begin
						pup_bit <= pup_bit + 1'b1;
						pup_state <= 3'b001;
					end
				end
				3'b101: begin
					pup_csb <= 1'b1;
					pup_state <= 3'b110;
				end
				3'b110: begin
					pup <= 1'b0;
					cpu_rstn <= 1'b1;
				end
			endcase
		end
	end

	// 0000 0011 000X AAAA AAAA AAAA AAAA AAAA
	// we want to make that X into a 1

	reg [4:0] bit_count;
	reg force_d0;
	always @(negedge cpu_sclk or posedge cpu_csb) begin
		if (cpu_csb) begin
			bit_count <= 4'b0;
			force_d0 <= 1'b0;
		end else begin
			if (bit_count < 31)
				bit_count <= bit_count + 1'b1;
			force_d0 <= (bit_count == 10);
		end
	end

	// adds latency but we have margin
	always @(posedge sys_clk) begin
		flash_sclk <= pup ? pup_clk : cpu_sclk;
		flash_csb <= pup ? pup_csb : cpu_csb;
		flash_d0 <= pup ? pup_d0 : (cpu_d0 | force_d0);
		cpu_d1 <= flash_d1;
	end

endmodule
