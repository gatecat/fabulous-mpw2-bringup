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

	input  P1A1, // SCLK
	input  P1A2, // GPIO
	output  P1A3, // D1
	input P1A4, // D0
	input P1A7, // CSB
	output P1A8, // XCLK
	output P1A9 // RSTN
);
	// reset
	assign RSTN = BTN_N;
	// clock divider
	reg divclk;
	always @(posedge CLK) divclk <= ~divclk;
	assign P1A8 = divclk;
	// flash bridge
	flash_mitm bridge_i (
		.cpu_sclk(P1A1),
		.cpu_csb(P1A7),
		.cpu_d0(P1A4),
		.cpu_d1(PA13),
		.flash_sclk(FLASH_SCK),
		.flash_csb(FLASH_SSB),
		.flash_d0(FLASH_IO0),
		.flash_d1(FLASH_IO1)
	);
	// monitor LEDs
	assign LEDR_N = P1A7;
	assign LEDG_N = ~P1A2;
endmodule

// Flash MITM
// The bitstream is located at 0x00000000 which is also where caravel expects boot code...
// Resolve this by tampering with the flash enough to set bit 20, shifting everything up a MB
module flash_mitm (
	input cpu_sclk,
	input cpu_csb,
	input cpu_d0,
	output cpu_d1,
	output flash_sclk,
	output flash_csb,
	output flash_d0,
	input flash_d1
);

	// 0000 0011 000X AAAA AAAA AAAA AAAA AAAA
	// we want to make that X into a 1

	reg [3:0] bit_count;
	reg force_d0;
	always @(negedge cpu_sclk or negedge cpu_csb) begin
		if (!cpu_csb) begin
			bit_count <= 4'b0;
			force_d0 <= 1'b0;
		end else begin
			if (bit_count < 13)
				bit_count <= bit_count + 1'b1;
			force_d0 <= (bit_count == 10);
		end
	end


	assign flash_sclk = cpu_sclk;
	assign flash_csb = cpu_csb;
	assign flash_d0 = cpu_d0 | force_d0;
	assign cpu_d1 = flash_d1;

endmodule
