from pathlib import Path
import sys
import re

pathlist = Path(sys.argv[1]).glob("*.v")
for path in pathlist:
     name = str(path.name)
     if not name.endswith("_tile.v") or name.endswith("DSP_tile.v"):
          continue
     with open(path, "r") as fi, open(f"{sys.argv[2]}/{name}", "w") as fo:
          need_endif = False
          for line in fi:
               if "parameter NoConfigBits" in line:
                    fo.write(line)
                    print("`ifdef EMULATION", file=fo)
                    print("parameter [639:0] Emulate_Bitstream = 640'b0;", file=fo)
                    print("`endif", file=fo)
               elif re.match(r'\s*[A-Z0-9a-z_]+_ConfigMem Inst_[A-Z0-9a-z_]+_ConfigMem \(\s*', line):
                    print("`ifdef EMULATION", file=fo)
                    print("assign ConfigBits = Emulate_Bitstream;", file=fo)
                    print("assign ConfigBits_N = ~Emulate_Bitstream;", file=fo)
                    print("`else", file=fo)
                    fo.write(line)
                    need_endif = True
               else:
                    fo.write(line)
                    if ");" in line and need_endif:
                         print("`endif", file=fo)
                         need_endif = False