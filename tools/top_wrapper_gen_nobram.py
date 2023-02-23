def gen(f):
    rows = 16
    bram_x = 10
    max_io = 31

    ports = [
        ("clk", 1),
        ("io_in", max_io),
        ("io_out", max_io),
        ("io_oeb", max_io)
    ]

    # num_bram = rows//2
    # for i in range(num_bram):
    #     ports += [
    #         (f"bram{i}_rd_addr", 8),
    #         (f"bram{i}_rd_data", 32),
    #         (f"bram{i}_wr_addr", 8),
    #         (f"bram{i}_wr_data", 32),
    #         (f"bram{i}_config", 8),
    #     ]

    print("module top_wrapper;", file=f)

    for p, w in ports:
        print(f"wire [{w-1}:0] {p};", file=f)
    print("", file=f)

    print("Global_Clock clk_i(.CLK(clk));", file=f)
    print("", file=f)

    for i in range(rows):
        for j in range(2):
            idx=31-(i*2+j)
            if idx < max_io:
                print(f'(* keep, BEL="X0Y{i+1}.{"AB"[j]}" *) IO_1_bidirectional_frame_config_pass io{idx}_i (.O(io_in[{idx}]), .I(io_out[{idx}]), .T(io_oeb[{idx}]));', file=f)
    print("", file=f)

    op_idx = 0
    def add_outpass(x, y, bel, sig, index):
        nonlocal op_idx
        conn = ", ".join(f".I{3-j}({sig}[{index+j}])" for j in range(4))
        print(f'(* keep, BEL="X{x}Y{y}.{bel}" *) OutPass4_frame_config op{op_idx}_i (.CLK(clk), {conn});', file=f)
        op_idx += 1
    def add_inpass(x, y, bel, sig, index):
        nonlocal op_idx
        conn = ", ".join(f".O{3-j}({sig}[{index+j}])" for j in range(4))
        print(f'(* keep, BEL="X{x}Y{y}.{bel}" *) InPass4_frame_config ip{op_idx}_i (.CLK(clk), {conn});', file=f)
        op_idx += 1

    # for i in range(num_bram):
    #     y0 = rows-(2*i)
    #     add_outpass(bram_x, y0, "FAB2RAM_A1", f"bram{i}_rd_addr", 0)
    #     add_outpass(bram_x, y0, "FAB2RAM_A0", f"bram{i}_rd_addr", 4)
    #     add_outpass(bram_x, y0-1, "FAB2RAM_A1", f"bram{i}_wr_addr", 0)
    #     add_outpass(bram_x, y0-1, "FAB2RAM_A0", f"bram{i}_wr_addr", 4)
    #     for j in range(8):
    #         add_outpass(bram_x, y0-(j//4), f"FAB2RAM_D{3-(j%4)}", f"bram{i}_wr_data", 4*j)
    #         add_inpass(bram_x, y0-(j//4), f"RAM2FAB_D{3-(j%4)}", f"bram{i}_rd_data", 4*j)
    #     add_outpass(bram_x, y0, "FAB2RAM_C", f"bram{i}_config", 0)
    #     add_outpass(bram_x, y0-1, "FAB2RAM_C", f"bram{i}_config", 4)
    #     print("", file=f)

    print(f"top top_i({', '.join(f'.{p}({p})' for p, w in ports)});", file=f)

    print("endmodule", file=f)

if __name__ == '__main__':
    import sys
    with open(sys.argv[1], "w") as f:
        gen(f)