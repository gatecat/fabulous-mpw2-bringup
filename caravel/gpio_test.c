#include "../defs.h"
#include "../gpio_config/gpio_config_io.c"

// --------------------------------------------------------
// Firmware routines
// --------------------------------------------------------

void set_registers() {

    reg_mprj_io_0 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_1 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_2 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_3 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_4 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_5 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_6 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_7 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_8 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_9 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_10 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_11 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_12 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_13 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_14 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_15 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_16 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_17 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_18 = GPIO_MODE_USER_STD_BIDIRECTIONAL;

    reg_mprj_io_19 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_20 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_21 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_22 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_23 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_24 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_25 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_26 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_27 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_28 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_29 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_30 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_31 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_32 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_33 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_34 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_35 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_36 = GPIO_MODE_USER_STD_BIDIRECTIONAL;
    reg_mprj_io_37 = GPIO_MODE_USER_STD_BIDIRECTIONAL;

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
    gpio_config_io();
    while(1) {
        /* reg_gpio_out = 0x0;
        delay(10000000);
        reg_gpio_out = 0x1;
        delay(10000000); */
    }
}
