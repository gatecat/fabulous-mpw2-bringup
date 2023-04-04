module top_wrapper;
wire [0:0] clk;
wire [9:0] io_in;
wire [9:0] io_out;
wire [9:0] io_oeb;

Global_Clock clk_i(.CLK(clk));

(* keep, BEL="X0Y10.A" *) IO_1_bidirectional_frame_config_pass io9_i (.O(io_in[9]), .I(io_out[9]), .T(io_oeb[9]));
(* keep, BEL="X0Y10.B" *) IO_1_bidirectional_frame_config_pass io8_i (.O(io_in[8]), .I(io_out[8]), .T(io_oeb[8]));
(* keep, BEL="X0Y11.A" *) IO_1_bidirectional_frame_config_pass io7_i (.O(io_in[7]), .I(io_out[7]), .T(io_oeb[7]));
(* keep, BEL="X0Y11.B" *) IO_1_bidirectional_frame_config_pass io6_i (.O(io_in[6]), .I(io_out[6]), .T(io_oeb[6]));
(* keep, BEL="X0Y12.A" *) IO_1_bidirectional_frame_config_pass io5_i (.O(io_in[5]), .I(io_out[5]), .T(io_oeb[5]));
(* keep, BEL="X0Y12.B" *) IO_1_bidirectional_frame_config_pass io4_i (.O(io_in[4]), .I(io_out[4]), .T(io_oeb[4]));
(* keep, BEL="X0Y13.A" *) IO_1_bidirectional_frame_config_pass io3_i (.O(io_in[3]), .I(io_out[3]), .T(io_oeb[3]));
(* keep, BEL="X0Y13.B" *) IO_1_bidirectional_frame_config_pass io2_i (.O(io_in[2]), .I(io_out[2]), .T(io_oeb[2]));
(* keep, BEL="X0Y14.A" *) IO_1_bidirectional_frame_config_pass io1_i (.O(io_in[1]), .I(io_out[1]), .T(io_oeb[1]));
(* keep, BEL="X0Y14.B" *) IO_1_bidirectional_frame_config_pass io0_i (.O(io_in[0]), .I(io_out[0]), .T(io_oeb[0]));

top top_i(.clk(clk), .io_in(io_in), .io_out(io_out), .io_oeb(io_oeb));
endmodule
