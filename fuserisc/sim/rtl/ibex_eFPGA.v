// SPDX-FileCopyrightText: 
// 2021 Andrew Attwood
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

module ibex_eFPGA (
	clk,
	rst_n,
	en_i,
	operator_i,
	ready_o,
	endresult_o,
	result_a_i,
	result_b_i,
	result_c_i,
	delay_i,
	write_strobe,
	efpga_done_i
);
	input wire clk;
	input wire rst_n;
	input wire en_i;
	input wire [1:0] operator_i;
	output wire ready_o;
	output reg [31:0] endresult_o;
	input wire [31:0] result_a_i;
	input wire [31:0] result_b_i;
	input wire [31:0] result_c_i;
	input wire [3:0] delay_i;
	output reg write_strobe;
	input wire efpga_done_i;
	reg [1:0] eFPGA_fsm_r;
	reg [3:0] count;
	localparam [1:0] eFINISH = 2;
	localparam [1:0] eIDLE = 0;
	localparam [1:0] ePROCESSING = 1;
	always @(posedge clk)
		if (!rst_n) begin
			eFPGA_fsm_r <= eIDLE;
			count <= 0;
			write_strobe <= 1'b0;
		end
		else
			case (eFPGA_fsm_r)
				eIDLE: begin
					count <= 0;
					if (en_i == 1) begin
						eFPGA_fsm_r <= ePROCESSING;
						if (operator_i == 2'b11)
							write_strobe <= 1'b1;
					end
				end
				ePROCESSING: begin
					count <= count + 1;
					if (((count == delay_i) & (delay_i != 4'b1111)) | ((delay_i == 4'b1111) & efpga_done_i)) begin
						eFPGA_fsm_r <= eFINISH;
						case (operator_i)
							2'b00: endresult_o <= result_a_i;
							2'b01: endresult_o <= result_b_i;
							2'b10: endresult_o <= result_c_i;
							2'b11: begin
								endresult_o <= result_a_i;
								write_strobe <= 1'b0;
							end
							default: endresult_o <= result_a_i;
						endcase
					end
				end
				eFINISH: eFPGA_fsm_r <= eIDLE;
				default:
					;
			endcase
	assign ready_o = eFPGA_fsm_r == eFINISH;
endmodule
