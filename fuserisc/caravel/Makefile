all: firmware.elf

%.elf: %.c ./sections.lds ./crt0.S
	riscv32-unknown-elf-gcc -O0 -mabi=ilp32 -march=rv32i -D__vexriscv__ -Wl,-Bstatic,-T,./sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ ./crt0.S  $<
	riscv32-unknown-elf-objdump -D $@ > $*.lst

%.bin: %.elf
	riscv32-unknown-elf-objcopy -O binary $< $@

%.prog: %.bin
	iceprog -o 1M $<
