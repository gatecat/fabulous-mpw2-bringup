// SPDX-FileCopyrightText: 
// 2021 Nguyen Dao
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
//NumberOfConfigBits:0
module E_CPU_IO_bot_switch_matrix (N1END0, N1END1, N1END2, N1END3, N2MID0, N2MID1, N2MID2, N2MID3, N2MID4, N2MID5, N2MID6, N2MID7, N2END0, N2END1, N2END2, N2END3, N2END4, N2END5, N2END6, N2END7, N4END0, N4END1, N4END2, N4END3, N4END4, N4END5, N4END6, N4END7, N4END8, N4END9, N4END10, N4END11, N4END12, N4END13, N4END14, N4END15, NN4END0, NN4END1, NN4END2, NN4END3, NN4END4, NN4END5, NN4END6, NN4END7, NN4END8, NN4END9, NN4END10, NN4END11, NN4END12, NN4END13, NN4END14, NN4END15, Ci0, E1END0, E1END1, E1END2, E1END3, E2MID0, E2MID1, E2MID2, E2MID3, E2MID4, E2MID5, E2MID6, E2MID7, E2END0, E2END1, E2END2, E2END3, E2END4, E2END5, E2END6, E2END7, EE4END0, EE4END1, EE4END2, EE4END3, EE4END4, EE4END5, EE4END6, EE4END7, EE4END8, EE4END9, EE4END10, EE4END11, EE4END12, EE4END13, EE4END14, EE4END15, E6END0, E6END1, E6END2, E6END3, E6END4, E6END5, E6END6, E6END7, E6END8, E6END9, E6END10, E6END11, OPA_O0, OPA_O1, OPA_O2, OPA_O3, OPB_O0, OPB_O1, OPB_O2, OPB_O3, S1BEG0, S1BEG1, S1BEG2, S1BEG3, S2BEG0, S2BEG1, S2BEG2, S2BEG3, S2BEG4, S2BEG5, S2BEG6, S2BEG7, S2BEGb0, S2BEGb1, S2BEGb2, S2BEGb3, S2BEGb4, S2BEGb5, S2BEGb6, S2BEGb7, S4BEG0, S4BEG1, S4BEG2, S4BEG3, S4BEG4, S4BEG5, S4BEG6, S4BEG7, S4BEG8, S4BEG9, S4BEG10, S4BEG11, S4BEG12, S4BEG13, S4BEG14, S4BEG15, SS4BEG0, SS4BEG1, SS4BEG2, SS4BEG3, SS4BEG4, SS4BEG5, SS4BEG6, SS4BEG7, SS4BEG8, SS4BEG9, SS4BEG10, SS4BEG11, SS4BEG12, SS4BEG13, SS4BEG14, SS4BEG15, W1BEG0, W1BEG1, W1BEG2, W1BEG3, W2BEG0, W2BEG1, W2BEG2, W2BEG3, W2BEG4, W2BEG5, W2BEG6, W2BEG7, W2BEGb0, W2BEGb1, W2BEGb2, W2BEGb3, W2BEGb4, W2BEGb5, W2BEGb6, W2BEGb7, WW4BEG0, WW4BEG1, WW4BEG2, WW4BEG3, WW4BEG4, WW4BEG5, WW4BEG6, WW4BEG7, WW4BEG8, WW4BEG9, WW4BEG10, WW4BEG11, WW4BEG12, WW4BEG13, WW4BEG14, WW4BEG15, W6BEG0, W6BEG1, W6BEG2, W6BEG3, W6BEG4, W6BEG5, W6BEG6, W6BEG7, W6BEG8, W6BEG9, W6BEG10, W6BEG11, RES0_I0, RES0_I1, RES0_I2, RES0_I3, RES1_I0, RES1_I1, RES1_I2, RES1_I3, RES2_I0, RES2_I1, RES2_I2, RES2_I3);
	parameter NoConfigBits = 0;
	 // switch matrix inputs
	input N1END0;
	input N1END1;
	input N1END2;
	input N1END3;
	input N2MID0;
	input N2MID1;
	input N2MID2;
	input N2MID3;
	input N2MID4;
	input N2MID5;
	input N2MID6;
	input N2MID7;
	input N2END0;
	input N2END1;
	input N2END2;
	input N2END3;
	input N2END4;
	input N2END5;
	input N2END6;
	input N2END7;
	input N4END0;
	input N4END1;
	input N4END2;
	input N4END3;
	input N4END4;
	input N4END5;
	input N4END6;
	input N4END7;
	input N4END8;
	input N4END9;
	input N4END10;
	input N4END11;
	input N4END12;
	input N4END13;
	input N4END14;
	input N4END15;
	input NN4END0;
	input NN4END1;
	input NN4END2;
	input NN4END3;
	input NN4END4;
	input NN4END5;
	input NN4END6;
	input NN4END7;
	input NN4END8;
	input NN4END9;
	input NN4END10;
	input NN4END11;
	input NN4END12;
	input NN4END13;
	input NN4END14;
	input NN4END15;
	input Ci0;
	input E1END0;
	input E1END1;
	input E1END2;
	input E1END3;
	input E2MID0;
	input E2MID1;
	input E2MID2;
	input E2MID3;
	input E2MID4;
	input E2MID5;
	input E2MID6;
	input E2MID7;
	input E2END0;
	input E2END1;
	input E2END2;
	input E2END3;
	input E2END4;
	input E2END5;
	input E2END6;
	input E2END7;
	input EE4END0;
	input EE4END1;
	input EE4END2;
	input EE4END3;
	input EE4END4;
	input EE4END5;
	input EE4END6;
	input EE4END7;
	input EE4END8;
	input EE4END9;
	input EE4END10;
	input EE4END11;
	input EE4END12;
	input EE4END13;
	input EE4END14;
	input EE4END15;
	input E6END0;
	input E6END1;
	input E6END2;
	input E6END3;
	input E6END4;
	input E6END5;
	input E6END6;
	input E6END7;
	input E6END8;
	input E6END9;
	input E6END10;
	input E6END11;
	input OPA_O0;
	input OPA_O1;
	input OPA_O2;
	input OPA_O3;
	input OPB_O0;
	input OPB_O1;
	input OPB_O2;
	input OPB_O3;
	output S1BEG0;
	output S1BEG1;
	output S1BEG2;
	output S1BEG3;
	output S2BEG0;
	output S2BEG1;
	output S2BEG2;
	output S2BEG3;
	output S2BEG4;
	output S2BEG5;
	output S2BEG6;
	output S2BEG7;
	output S2BEGb0;
	output S2BEGb1;
	output S2BEGb2;
	output S2BEGb3;
	output S2BEGb4;
	output S2BEGb5;
	output S2BEGb6;
	output S2BEGb7;
	output S4BEG0;
	output S4BEG1;
	output S4BEG2;
	output S4BEG3;
	output S4BEG4;
	output S4BEG5;
	output S4BEG6;
	output S4BEG7;
	output S4BEG8;
	output S4BEG9;
	output S4BEG10;
	output S4BEG11;
	output S4BEG12;
	output S4BEG13;
	output S4BEG14;
	output S4BEG15;
	output SS4BEG0;
	output SS4BEG1;
	output SS4BEG2;
	output SS4BEG3;
	output SS4BEG4;
	output SS4BEG5;
	output SS4BEG6;
	output SS4BEG7;
	output SS4BEG8;
	output SS4BEG9;
	output SS4BEG10;
	output SS4BEG11;
	output SS4BEG12;
	output SS4BEG13;
	output SS4BEG14;
	output SS4BEG15;
	output W1BEG0;
	output W1BEG1;
	output W1BEG2;
	output W1BEG3;
	output W2BEG0;
	output W2BEG1;
	output W2BEG2;
	output W2BEG3;
	output W2BEG4;
	output W2BEG5;
	output W2BEG6;
	output W2BEG7;
	output W2BEGb0;
	output W2BEGb1;
	output W2BEGb2;
	output W2BEGb3;
	output W2BEGb4;
	output W2BEGb5;
	output W2BEGb6;
	output W2BEGb7;
	output WW4BEG0;
	output WW4BEG1;
	output WW4BEG2;
	output WW4BEG3;
	output WW4BEG4;
	output WW4BEG5;
	output WW4BEG6;
	output WW4BEG7;
	output WW4BEG8;
	output WW4BEG9;
	output WW4BEG10;
	output WW4BEG11;
	output WW4BEG12;
	output WW4BEG13;
	output WW4BEG14;
	output WW4BEG15;
	output W6BEG0;
	output W6BEG1;
	output W6BEG2;
	output W6BEG3;
	output W6BEG4;
	output W6BEG5;
	output W6BEG6;
	output W6BEG7;
	output W6BEG8;
	output W6BEG9;
	output W6BEG10;
	output W6BEG11;
	output RES0_I0;
	output RES0_I1;
	output RES0_I2;
	output RES0_I3;
	output RES1_I0;
	output RES1_I1;
	output RES1_I2;
	output RES1_I3;
	output RES2_I0;
	output RES2_I1;
	output RES2_I2;
	output RES2_I3;
	//global


	parameter GND0 = 1'b0;
	parameter GND = 1'b0;
	parameter VCC0 = 1'b1;
	parameter VCC = 1'b1;
	parameter VDD0 = 1'b1;
	parameter VDD = 1'b1;
	
	wire [1-1:0] S1BEG0_input;
	wire [1-1:0] S1BEG1_input;
	wire [1-1:0] S1BEG2_input;
	wire [1-1:0] S1BEG3_input;
	wire [1-1:0] S2BEG0_input;
	wire [1-1:0] S2BEG1_input;
	wire [1-1:0] S2BEG2_input;
	wire [1-1:0] S2BEG3_input;
	wire [1-1:0] S2BEG4_input;
	wire [1-1:0] S2BEG5_input;
	wire [1-1:0] S2BEG6_input;
	wire [1-1:0] S2BEG7_input;
	wire [1-1:0] S2BEGb0_input;
	wire [1-1:0] S2BEGb1_input;
	wire [1-1:0] S2BEGb2_input;
	wire [1-1:0] S2BEGb3_input;
	wire [1-1:0] S2BEGb4_input;
	wire [1-1:0] S2BEGb5_input;
	wire [1-1:0] S2BEGb6_input;
	wire [1-1:0] S2BEGb7_input;
	wire [1-1:0] S4BEG0_input;
	wire [1-1:0] S4BEG1_input;
	wire [1-1:0] S4BEG2_input;
	wire [1-1:0] S4BEG3_input;
	wire [1-1:0] S4BEG4_input;
	wire [1-1:0] S4BEG5_input;
	wire [1-1:0] S4BEG6_input;
	wire [1-1:0] S4BEG7_input;
	wire [1-1:0] S4BEG8_input;
	wire [1-1:0] S4BEG9_input;
	wire [1-1:0] S4BEG10_input;
	wire [1-1:0] S4BEG11_input;
	wire [1-1:0] S4BEG12_input;
	wire [1-1:0] S4BEG13_input;
	wire [1-1:0] S4BEG14_input;
	wire [1-1:0] S4BEG15_input;
	wire [1-1:0] SS4BEG0_input;
	wire [1-1:0] SS4BEG1_input;
	wire [1-1:0] SS4BEG2_input;
	wire [1-1:0] SS4BEG3_input;
	wire [1-1:0] SS4BEG4_input;
	wire [1-1:0] SS4BEG5_input;
	wire [1-1:0] SS4BEG6_input;
	wire [1-1:0] SS4BEG7_input;
	wire [1-1:0] SS4BEG8_input;
	wire [1-1:0] SS4BEG9_input;
	wire [1-1:0] SS4BEG10_input;
	wire [1-1:0] SS4BEG11_input;
	wire [1-1:0] SS4BEG12_input;
	wire [1-1:0] SS4BEG13_input;
	wire [1-1:0] SS4BEG14_input;
	wire [1-1:0] SS4BEG15_input;
	wire [1-1:0] W1BEG0_input;
	wire [1-1:0] W1BEG1_input;
	wire [1-1:0] W1BEG2_input;
	wire [1-1:0] W1BEG3_input;
	wire [1-1:0] W2BEG0_input;
	wire [1-1:0] W2BEG1_input;
	wire [1-1:0] W2BEG2_input;
	wire [1-1:0] W2BEG3_input;
	wire [1-1:0] W2BEG4_input;
	wire [1-1:0] W2BEG5_input;
	wire [1-1:0] W2BEG6_input;
	wire [1-1:0] W2BEG7_input;
	wire [1-1:0] W2BEGb0_input;
	wire [1-1:0] W2BEGb1_input;
	wire [1-1:0] W2BEGb2_input;
	wire [1-1:0] W2BEGb3_input;
	wire [1-1:0] W2BEGb4_input;
	wire [1-1:0] W2BEGb5_input;
	wire [1-1:0] W2BEGb6_input;
	wire [1-1:0] W2BEGb7_input;
	wire [0-1:0] WW4BEG0_input;
	wire [0-1:0] WW4BEG1_input;
	wire [0-1:0] WW4BEG2_input;
	wire [0-1:0] WW4BEG3_input;
	wire [0-1:0] WW4BEG4_input;
	wire [0-1:0] WW4BEG5_input;
	wire [0-1:0] WW4BEG6_input;
	wire [0-1:0] WW4BEG7_input;
	wire [0-1:0] WW4BEG8_input;
	wire [0-1:0] WW4BEG9_input;
	wire [0-1:0] WW4BEG10_input;
	wire [0-1:0] WW4BEG11_input;
	wire [0-1:0] WW4BEG12_input;
	wire [0-1:0] WW4BEG13_input;
	wire [0-1:0] WW4BEG14_input;
	wire [0-1:0] WW4BEG15_input;
	wire [1-1:0] W6BEG0_input;
	wire [1-1:0] W6BEG1_input;
	wire [1-1:0] W6BEG2_input;
	wire [1-1:0] W6BEG3_input;
	wire [1-1:0] W6BEG4_input;
	wire [1-1:0] W6BEG5_input;
	wire [1-1:0] W6BEG6_input;
	wire [1-1:0] W6BEG7_input;
	wire [1-1:0] W6BEG8_input;
	wire [1-1:0] W6BEG9_input;
	wire [1-1:0] W6BEG10_input;
	wire [1-1:0] W6BEG11_input;
	wire [1-1:0] RES0_I0_input;
	wire [1-1:0] RES0_I1_input;
	wire [1-1:0] RES0_I2_input;
	wire [1-1:0] RES0_I3_input;
	wire [1-1:0] RES1_I0_input;
	wire [1-1:0] RES1_I1_input;
	wire [1-1:0] RES1_I2_input;
	wire [1-1:0] RES1_I3_input;
	wire [1-1:0] RES2_I0_input;
	wire [1-1:0] RES2_I1_input;
	wire [1-1:0] RES2_I2_input;
	wire [1-1:0] RES2_I3_input;


// The configuration bits (if any) are just a long shift register

// This shift register is padded to an even number of flops/latches
// switch matrix multiplexer  S1BEG0 		MUX-1
	assign S1BEG0 = N1END3;
// switch matrix multiplexer  S1BEG1 		MUX-1
	assign S1BEG1 = N1END2;
// switch matrix multiplexer  S1BEG2 		MUX-1
	assign S1BEG2 = N1END1;
// switch matrix multiplexer  S1BEG3 		MUX-1
	assign S1BEG3 = N1END0;
// switch matrix multiplexer  S2BEG0 		MUX-1
	assign S2BEG0 = N2MID7;
// switch matrix multiplexer  S2BEG1 		MUX-1
	assign S2BEG1 = N2MID6;
// switch matrix multiplexer  S2BEG2 		MUX-1
	assign S2BEG2 = N2MID5;
// switch matrix multiplexer  S2BEG3 		MUX-1
	assign S2BEG3 = N2MID4;
// switch matrix multiplexer  S2BEG4 		MUX-1
	assign S2BEG4 = N2MID3;
// switch matrix multiplexer  S2BEG5 		MUX-1
	assign S2BEG5 = N2MID2;
// switch matrix multiplexer  S2BEG6 		MUX-1
	assign S2BEG6 = N2MID1;
// switch matrix multiplexer  S2BEG7 		MUX-1
	assign S2BEG7 = N2MID0;
// switch matrix multiplexer  S2BEGb0 		MUX-1
	assign S2BEGb0 = N2END7;
// switch matrix multiplexer  S2BEGb1 		MUX-1
	assign S2BEGb1 = N2END6;
// switch matrix multiplexer  S2BEGb2 		MUX-1
	assign S2BEGb2 = N2END5;
// switch matrix multiplexer  S2BEGb3 		MUX-1
	assign S2BEGb3 = N2END4;
// switch matrix multiplexer  S2BEGb4 		MUX-1
	assign S2BEGb4 = N2END3;
// switch matrix multiplexer  S2BEGb5 		MUX-1
	assign S2BEGb5 = N2END2;
// switch matrix multiplexer  S2BEGb6 		MUX-1
	assign S2BEGb6 = N2END1;
// switch matrix multiplexer  S2BEGb7 		MUX-1
	assign S2BEGb7 = N2END0;
// switch matrix multiplexer  S4BEG0 		MUX-1
	assign S4BEG0 = N4END15;
// switch matrix multiplexer  S4BEG1 		MUX-1
	assign S4BEG1 = N4END14;
// switch matrix multiplexer  S4BEG2 		MUX-1
	assign S4BEG2 = N4END13;
// switch matrix multiplexer  S4BEG3 		MUX-1
	assign S4BEG3 = N4END12;
// switch matrix multiplexer  S4BEG4 		MUX-1
	assign S4BEG4 = N4END11;
// switch matrix multiplexer  S4BEG5 		MUX-1
	assign S4BEG5 = N4END10;
// switch matrix multiplexer  S4BEG6 		MUX-1
	assign S4BEG6 = N4END9;
// switch matrix multiplexer  S4BEG7 		MUX-1
	assign S4BEG7 = N4END8;
// switch matrix multiplexer  S4BEG8 		MUX-1
	assign S4BEG8 = N4END7;
// switch matrix multiplexer  S4BEG9 		MUX-1
	assign S4BEG9 = N4END6;
// switch matrix multiplexer  S4BEG10 		MUX-1
	assign S4BEG10 = N4END5;
// switch matrix multiplexer  S4BEG11 		MUX-1
	assign S4BEG11 = N4END4;
// switch matrix multiplexer  S4BEG12 		MUX-1
	assign S4BEG12 = N4END3;
// switch matrix multiplexer  S4BEG13 		MUX-1
	assign S4BEG13 = N4END2;
// switch matrix multiplexer  S4BEG14 		MUX-1
	assign S4BEG14 = N4END1;
// switch matrix multiplexer  S4BEG15 		MUX-1
	assign S4BEG15 = N4END0;
// switch matrix multiplexer  SS4BEG0 		MUX-1
	assign SS4BEG0 = NN4END15;
// switch matrix multiplexer  SS4BEG1 		MUX-1
	assign SS4BEG1 = NN4END14;
// switch matrix multiplexer  SS4BEG2 		MUX-1
	assign SS4BEG2 = NN4END13;
// switch matrix multiplexer  SS4BEG3 		MUX-1
	assign SS4BEG3 = NN4END12;
// switch matrix multiplexer  SS4BEG4 		MUX-1
	assign SS4BEG4 = NN4END11;
// switch matrix multiplexer  SS4BEG5 		MUX-1
	assign SS4BEG5 = NN4END10;
// switch matrix multiplexer  SS4BEG6 		MUX-1
	assign SS4BEG6 = NN4END9;
// switch matrix multiplexer  SS4BEG7 		MUX-1
	assign SS4BEG7 = NN4END8;
// switch matrix multiplexer  SS4BEG8 		MUX-1
	assign SS4BEG8 = NN4END7;
// switch matrix multiplexer  SS4BEG9 		MUX-1
	assign SS4BEG9 = NN4END6;
// switch matrix multiplexer  SS4BEG10 		MUX-1
	assign SS4BEG10 = NN4END5;
// switch matrix multiplexer  SS4BEG11 		MUX-1
	assign SS4BEG11 = NN4END4;
// switch matrix multiplexer  SS4BEG12 		MUX-1
	assign SS4BEG12 = NN4END3;
// switch matrix multiplexer  SS4BEG13 		MUX-1
	assign SS4BEG13 = NN4END2;
// switch matrix multiplexer  SS4BEG14 		MUX-1
	assign SS4BEG14 = NN4END1;
// switch matrix multiplexer  SS4BEG15 		MUX-1
	assign SS4BEG15 = NN4END0;
// switch matrix multiplexer  W1BEG0 		MUX-1
	assign W1BEG0 = E1END3;
// switch matrix multiplexer  W1BEG1 		MUX-1
	assign W1BEG1 = E1END2;
// switch matrix multiplexer  W1BEG2 		MUX-1
	assign W1BEG2 = E1END1;
// switch matrix multiplexer  W1BEG3 		MUX-1
	assign W1BEG3 = E1END0;
// switch matrix multiplexer  W2BEG0 		MUX-1
	assign W2BEG0 = OPB_O0;
// switch matrix multiplexer  W2BEG1 		MUX-1
	assign W2BEG1 = E2MID6;
// switch matrix multiplexer  W2BEG2 		MUX-1
	assign W2BEG2 = E2MID5;
// switch matrix multiplexer  W2BEG3 		MUX-1
	assign W2BEG3 = OPB_O1;
// switch matrix multiplexer  W2BEG4 		MUX-1
	assign W2BEG4 = OPB_O2;
// switch matrix multiplexer  W2BEG5 		MUX-1
	assign W2BEG5 = E2MID2;
// switch matrix multiplexer  W2BEG6 		MUX-1
	assign W2BEG6 = E2MID1;
// switch matrix multiplexer  W2BEG7 		MUX-1
	assign W2BEG7 = OPB_O3;
// switch matrix multiplexer  W2BEGb0 		MUX-1
	assign W2BEGb0 = OPA_O0;
// switch matrix multiplexer  W2BEGb1 		MUX-1
	assign W2BEGb1 = E2END6;
// switch matrix multiplexer  W2BEGb2 		MUX-1
	assign W2BEGb2 = E2END5;
// switch matrix multiplexer  W2BEGb3 		MUX-1
	assign W2BEGb3 = OPA_O1;
// switch matrix multiplexer  W2BEGb4 		MUX-1
	assign W2BEGb4 = OPA_O2;
// switch matrix multiplexer  W2BEGb5 		MUX-1
	assign W2BEGb5 = E2END2;
// switch matrix multiplexer  W2BEGb6 		MUX-1
	assign W2BEGb6 = E2END1;
// switch matrix multiplexer  W2BEGb7 		MUX-1
	assign W2BEGb7 = OPA_O3;
// switch matrix multiplexer  WW4BEG0 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG0
// switch matrix multiplexer  WW4BEG1 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG1
// switch matrix multiplexer  WW4BEG2 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG2
// switch matrix multiplexer  WW4BEG3 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG3
// switch matrix multiplexer  WW4BEG4 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG4
// switch matrix multiplexer  WW4BEG5 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG5
// switch matrix multiplexer  WW4BEG6 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG6
// switch matrix multiplexer  WW4BEG7 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG7
// switch matrix multiplexer  WW4BEG8 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG8
// switch matrix multiplexer  WW4BEG9 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG9
// switch matrix multiplexer  WW4BEG10 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG10
// switch matrix multiplexer  WW4BEG11 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG11
// switch matrix multiplexer  WW4BEG12 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG12
// switch matrix multiplexer  WW4BEG13 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG13
// switch matrix multiplexer  WW4BEG14 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG14
// switch matrix multiplexer  WW4BEG15 		MUX-0
// WARNING unused multiplexer MUX-WW4BEG15
// switch matrix multiplexer  W6BEG0 		MUX-1
	assign W6BEG0 = OPA_O0;
// switch matrix multiplexer  W6BEG1 		MUX-1
	assign W6BEG1 = OPA_O1;
// switch matrix multiplexer  W6BEG2 		MUX-1
	assign W6BEG2 = OPB_O0;
// switch matrix multiplexer  W6BEG3 		MUX-1
	assign W6BEG3 = OPB_O1;
// switch matrix multiplexer  W6BEG4 		MUX-1
	assign W6BEG4 = GND0;
// switch matrix multiplexer  W6BEG5 		MUX-1
	assign W6BEG5 = GND0;
// switch matrix multiplexer  W6BEG6 		MUX-1
	assign W6BEG6 = OPA_O2;
// switch matrix multiplexer  W6BEG7 		MUX-1
	assign W6BEG7 = OPA_O3;
// switch matrix multiplexer  W6BEG8 		MUX-1
	assign W6BEG8 = OPB_O2;
// switch matrix multiplexer  W6BEG9 		MUX-1
	assign W6BEG9 = OPB_O3;
// switch matrix multiplexer  W6BEG10 		MUX-1
	assign W6BEG10 = GND0;
// switch matrix multiplexer  W6BEG11 		MUX-1
	assign W6BEG11 = GND0;
// switch matrix multiplexer  RES0_I0 		MUX-1
	assign RES0_I0 = E6END0;
// switch matrix multiplexer  RES0_I1 		MUX-1
	assign RES0_I1 = E6END1;
// switch matrix multiplexer  RES0_I2 		MUX-1
	assign RES0_I2 = E6END2;
// switch matrix multiplexer  RES0_I3 		MUX-1
	assign RES0_I3 = E6END3;
// switch matrix multiplexer  RES1_I0 		MUX-1
	assign RES1_I0 = E6END4;
// switch matrix multiplexer  RES1_I1 		MUX-1
	assign RES1_I1 = E6END5;
// switch matrix multiplexer  RES1_I2 		MUX-1
	assign RES1_I2 = E6END6;
// switch matrix multiplexer  RES1_I3 		MUX-1
	assign RES1_I3 = E6END7;
// switch matrix multiplexer  RES2_I0 		MUX-1
	assign RES2_I0 = E6END8;
// switch matrix multiplexer  RES2_I1 		MUX-1
	assign RES2_I1 = E6END9;
// switch matrix multiplexer  RES2_I2 		MUX-1
	assign RES2_I2 = E6END10;
// switch matrix multiplexer  RES2_I3 		MUX-1
	assign RES2_I3 = E6END11;

endmodule
