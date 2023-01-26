`timescale 1ps/1ps
module fab_tb;
    wire [30:0] I_top;
    wire [30:0] T_top;
    reg [30:0] O_top = 0;
    wire [63:0] A_cfg, B_cfg;

    reg CLK = 1'b0;
    wire clk_sel = 2'b00; // external clock
    reg resetn = 1'b1;
    reg Rx = 1'b1;
    wire ComActive;
    wire ReceiveLED;
    reg s_clk = 1'b0;
    reg s_data = 1'b0;

    wire [37:0] io_in, io_out, io_oeb;

    // Instantiate both the fabric and the reference DUT
    eFPGA_top top_i (
        .wb_clk_i(1'b0),
        .wbs_stb_i(1'b0),
        .wbs_cyc_i(1'b0),
        .wbs_we_i(1'b0),
        .user_clock2(1'b0),
        .wbs_dat_i(32'b0),
        .wbs_adr_i(32'b0),
        .wbs_dat_o(32'b0),
        .la_data_out(),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb),
    );

    assign io_in[5:0] = {Rx, s_data, s_clk, clk_sel, CLK};
    assign ReceiveLED = io_in[6];
    assign I_top = io_in[37:7];
    assign O_top = io_out[37:7];

    wire [30:0] I_top_gold, oeb_gold, T_top_gold;
    top dut_i (
        .clk(CLK),
        .io_out(I_top_gold),
        .io_oeb(oeb_gold),
        .io_in(O_top)
    );

    assign T_top_gold = ~oeb_gold;

    localparam MAX_BITBYTES = 16384;
    reg [7:0] bitstream[0:MAX_BITBYTES-1];

    always #5000 CLK = (CLK === 1'b0);

    integer i;
    reg have_errors = 1'b0;
    initial begin
`ifdef CREATE_FST
        $dumpfile("fab_tb.fst");
        $dumpvars(0, fab_tb);
`endif
        $readmemh("bitstream.hex", bitstream);
        #100;
        resetn = 1'b0;
        #10000;
        resetn = 1'b1;
        #10000;
        repeat (20) @(posedge CLK);
        #2500;
        // TODO: model bitbang or UART configure
        repeat (100) @(posedge CLK);
        O_top = 28'b1; // reset
        repeat (5) @(posedge CLK);
        O_top = 28'b0;
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge CLK);
            $display("fabric(I_top) = 0x%X gold = 0x%X, fabric(T_top) = 0x%X gold = 0x%X", I_top, I_top_gold, T_top, T_top_gold);
            if (I_top !== I_top_gold)
                have_errors = 1'b1;
            if (T_top !== T_top_gold)
                have_errors = 1'b1;
        end

        if (have_errors)
            $fatal;
        else
            $finish;
    end

endmodule

module clk_buf(input A, output X);
assign X = A;
endmodule

