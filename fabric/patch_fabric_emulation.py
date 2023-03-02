import sys, re
# Backport emulation parameters to old fabric verilog for testing purposes

with open(sys.argv[1], "r") as fi, open(sys.argv[2], "w") as fo:
    for line in fi:
        if m := re.match(r'\s+([A-Za-z0-9_]+) Tile_X(\d+)Y(\d+)_([A-Za-z0-9a-z_]+) \(\s*', line):
            # tile instance
            tt = m.group(1)
            tx = int(m.group(2))
            ty = int(m.group(3))
            if tt == "DSP":
                # SuperTile, special case for now
                emul_params = [
                    f".top_Emulate_Bitstream(`Tile_X{tx}Y{ty}_Emulate_Bitstream)",
                    f".bot_Emulate_Bitstream(`Tile_X{tx}Y{ty+1}_Emulate_Bitstream)",
                ]
            else:
                emul_params = [f".Emulate_Bitstream(`Tile_X{tx}Y{ty}_Emulate_Bitstream)"]
            print(f"\t{tt} ", file=fo)
            print("`ifdef EMULATION", file=fo)
            print(f"\t#({', '.join(emul_params)})", file=fo)
            print("`endif", file=fo)
            print(f"\tTile_X{tx}Y{ty}_{m.group(4)} (", file=fo)
        else:
            fo.write(line)
