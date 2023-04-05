`timescale 1ps/1ps
module testbench;
    reg clk, rst = 1'b1;

    wire [37:0] io_in, io_out, io_oeb;

    reg wb_stb = 1'b0, wb_cyc = 1'b0, wb_we = 1'b0;
    reg [3:0] wb_sel = 4'b0000;
    reg [31:0] wb_adr = 32'b0, wb_dat_i = 32'b0;
    wire [31:0] wb_dat_o;
    wire wb_ack_o;

    // Instantiate both the fabric and the reference DUT
    user_project_wrapper top_i (
        .wb_clk_i(clk),
        .wb_rst_i(rst),
        .wbs_stb_i(wb_stb),
        .wbs_cyc_i(wb_cyc),
        .wbs_sel_i(wb_sel),
        .wbs_we_i(wb_we),
        .user_clock2(1'b0),
        .wbs_dat_i(wb_dat_i),
        .wbs_adr_i(wb_adr),
        .wbs_dat_o(wb_dat_o),
        .wbs_ack_o(wb_ack_o),
        .la_data_in(1'b0),
        .la_data_out(),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb)
    );

    always #5000 clk = (clk === 1'b0);

    reg s_clk, s_data;

    reg [9:0] O_top = 10'b0;

    assign io_in[0] = 1'b0; // clock
    assign io_in[2:1] = 2'b01; // clock select (WB)
    assign io_in[3] = s_clk; // s_clk
    assign io_in[4] = s_data; // s_data
    assign io_in[5] = 1'b1; // rx
    assign io_in[16:6] = 1'b0; // other cruft
    assign io_in[25:17] = O_top; // fabric in
    assign io_in[37:26] = 1'b0;

    integer timeout;

    localparam MAX_BITBYTES=19200;
    reg [7:0] bitstream[0:MAX_BITBYTES-1];
    localparam [31:0] ctrl_word = 32'h0000FAB1;


    wire [9:0] I_top = io_out[25:17];
    wire [9:0] T_top = io_oeb[25:17];


    integer i, j;

    initial begin
        $dumpfile("fabric.fst");
        $dumpvars(0, testbench);

        $readmemh("bitstream.hex", bitstream);

        repeat (100) @(posedge clk);
        rst = 1'b0;
        repeat (100) @(posedge clk);
        #2500;

        for (i = 0; i < MAX_BITBYTES; i = i + 4) begin
            if ((i % 100) == 0)
                $display("bit %d", i);
            for (j = 0; j < 32; j = j + 1) begin
                s_data = bitstream[i + (j / 8)][7 - (j % 8)]; // data bit
                repeat (1) @(posedge clk);
                s_clk = 1'b1; // rising
                repeat (1) @(posedge clk);
                s_data = ctrl_word[31-j];
                repeat (1) @(posedge clk);
                s_clk = 1'b0;
                repeat (2) @(posedge clk);
            end
        end

        repeat (100) @(posedge clk);
        O_top = 28'b1; // reset
        repeat (5) @(posedge clk);
        O_top = 28'b0;

        for (i = 0; i < 100; i = i + 1) begin
            repeat (1) @(negedge clk);
            $display("fabric(I_top) = 0x%X fabric(T_top) = 0x%X", I_top, T_top);
        end

        repeat (10000) @(posedge clk);
        $finish;
    end

endmodule

