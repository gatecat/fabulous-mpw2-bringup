`timescale 1ps/1ps
module testbench;
    reg clk, rst = 1'b1;

    wire [37:0] io_in, io_out, io_oeb;

    reg wb_stb, wb_cyc, wb_we;
    reg [3:0] wb_sel;
    reg [31:0] wb_adr, wb_dat_i;
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

    assign io_in[0] = 1'b0; // clock
    assign io_in[2:1] = 2'b01; // clock select (WB)
    assign io_in[3] = 1'b0; // s_clk
    assign io_in[4] = 1'b0; // s_data
    assign io_in[5] = 1'b1; // rx
    assign io_in[37:6] = 1'b0; // other cruft

    integer timeout;

    initial begin
        $dumpfile("wishbone_xfer.fst");
        $dumpvars(0, testbench);
        repeat (100) @(posedge clk);
        rst = 1'b0;
        repeat (100) @(posedge clk);
        #5;
        wb_adr = 32'h30000000;
        wb_dat_i = 32'h00000055;
        wb_sel = 4'hF;
        wb_stb = 1'b1;
        wb_cyc = 1'b1;
        wb_we = 1'b1;
        timeout = 0;
        while (!wb_ack_o && timeout < 100) begin
            @(posedge clk);
            #5;
            timeout += 1;
        end

        wb_stb = 1'b0;
        wb_cyc = 1'b0;
        repeat (1) @(posedge clk);
        #5;
        wb_stb = 1'b1;
        wb_cyc = 1'b1;
        wb_we = 1'b0;
        timeout = 0;
        while (!wb_ack_o && timeout < 100) begin
            @(posedge clk);
            #5;
            timeout += 1;
        end

        repeat (10000) @(posedge clk);
        $finish;
    end

endmodule

