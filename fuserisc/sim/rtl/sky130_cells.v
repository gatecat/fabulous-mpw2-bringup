module sky130_fd_sc_hd__conb_1(output LO, output HI);
	assign LO = 1'b0;
	assign HI = 1'b1;
endmodule

module sky130_fd_sc_hd__buf_2(input A, output X);
	assign X = A;
endmodule


module sky130_fd_sc_hd__mux2_1(input A0, A1, S, output X);
	assign X = S ? A1 : A0;
endmodule

