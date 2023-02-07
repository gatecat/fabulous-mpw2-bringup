#include "../defs.h"
#include "../gpio_config/gpio_config_io.c"

// --------------------------------------------------------
// Firmware routines
// --------------------------------------------------------

void set_registers() {

    reg_mprj_io_18 = 0x0;
    reg_mprj_io_17 = 0x1fe1;
    reg_mprj_io_16 = 0x1fc3;
    reg_mprj_io_15 = 0x1f87;
    reg_mprj_io_14 = 0x1f0f;
    reg_mprj_io_13 = 0x1e1f;
    reg_mprj_io_12 = 0x1c0f;
    reg_mprj_io_11 = 0x18ff;
    reg_mprj_io_10 = 0x11ff;
    reg_mprj_io_9 = 0x1fe;
    reg_mprj_io_8 = 0x1fc;
    reg_mprj_io_7 = 0x1f8;
    reg_mprj_io_6 = 0x3f0;
    reg_mprj_io_5 = 0x7e0;
    reg_mprj_io_4 = 0xec0;
    reg_mprj_io_3 = 0xd80;
    reg_mprj_io_2 = 0x1900;
    reg_mprj_io_1 = 0x1201;
    reg_mprj_io_0 = 0x402;
    reg_mprj_io_19 = 0x0;
    reg_mprj_io_20 = 0x1e0;
    reg_mprj_io_21 = 0x3c0;
    reg_mprj_io_22 = 0x380;
    reg_mprj_io_23 = 0x700;
    reg_mprj_io_24 = 0xe00;
    reg_mprj_io_25 = 0x1c01;
    reg_mprj_io_26 = 0x1803;
    reg_mprj_io_27 = 0x1007;
    reg_mprj_io_28 = 0x6;
    reg_mprj_io_29 = 0xc;
    reg_mprj_io_30 = 0x18;
    reg_mprj_io_31 = 0x30;
    reg_mprj_io_32 = 0xc0;
    reg_mprj_io_33 = 0x180;
    reg_mprj_io_34 = 0x300;
    reg_mprj_io_35 = 0x600;
    reg_mprj_io_36 = 0xc00;
    reg_mprj_io_37 = 0x1801;

    reg_mprj_xfer = 1;
    while ((reg_mprj_xfer & 0x1) == 1);

}

void main()
{
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oe = 1;

    set_registers();
    reg_mprj_datah = 0;
    reg_mprj_datal = 0;
    // gpio_config_io();
    reg_la0_oenb = reg_la0_iena = 0xFFFFFFFF;
    reg_gpio_out = 1; // OFF

	while(1) {
        uint32_t la =  reg_la0_data;
        reg_mprj_datah = la;
        reg_mprj_datal = 0;
        reg_gpio_out = ((la >> 1) & 0x1);
	}

}
