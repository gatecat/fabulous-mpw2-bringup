`timescale 1ps/1ps
module fab_tb;
    wire [30:0] I_top;
    wire [30:0] T_top;
    reg [30:0] O_top = 0;
    wire [63:0] A_cfg, B_cfg;

    reg CLK = 1'b0;
    wire [1:0] clk_sel = 2'b00; // external clock
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
        .wbs_dat_o(),
        .la_data_out(),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb)
    );

    assign io_in[5:0] = {Rx, s_data, s_clk, clk_sel, CLK};
    assign ReceiveLED = io_out[6];
    assign io_in[37:7] = O_top;
    assign I_top = io_out[37:7];
    assign T_top = io_oeb[37:7];

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

    integer i, j;
    reg have_errors = 1'b0;
    localparam [31:0] ctrl_word = 32'h0000FAB1;
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
        s_clk = 1'b0;
        #10000;
        repeat (20) @(posedge CLK);
        #2500;
        for (i = 0; i < MAX_BITBYTES; i = i + 4) begin
            if ((i % 100) == 0)
                $display("bit %d", i);
            for (j = 0; j < 32; j = j + 1) begin
                s_data = bitstream[i + (j / 8)][7 - (j % 8)]; // data bit
                repeat (1) @(posedge CLK);
                s_clk = 1'b1; // rising
                repeat (1) @(posedge CLK);
                s_data = ctrl_word[31-j];
                repeat (1) @(posedge CLK);
                s_clk = 1'b0;
                repeat (2) @(posedge CLK);
            end
        end
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

