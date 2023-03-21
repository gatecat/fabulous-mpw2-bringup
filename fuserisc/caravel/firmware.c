#include "./defs.h"

uint16_t flag;

static inline void irq_setmask(unsigned int mask)
{
    asm volatile ("csrw %0, %1" :: "i"(CSR_IRQ_MASK), "r"(mask));
}

void isr(void)
{
   irq_setmask(0);
   reg_timer0_irq_en = 0; // disable interrupt
   reg_timer0_update = 1;
   if (reg_timer0_value == 0)
       flag = 1;
   else
       reg_timer0_irq_en = 1;
    return;
}


void delay(const int d)
{

    /* Configure timer for a single-shot countdown */
    reg_timer0_config = 0;
    reg_timer0_data = d;
    reg_timer0_config = 1;

    // Loop, waiting for value to reach zero
   reg_timer0_update = 1;  // latch current value
   while (reg_timer0_value > 0) {
           reg_timer0_update = 1;
   }

}

void putchar_impl(uint8_t ch, volatile uint32_t *reg);

void putchar(char c)
{
    if (c == '\n')
        putchar('\r');
    putchar_impl(c, &reg_gpio_out);
}

void print(const char *p)
{
    while (*p)
        putchar(*(p++));
}

void print_hex(uint32_t v, int digits)
{
    for (int i = digits - 1; i >= 0; i--) {
        char c = "0123456789abcdef"[(v >> (4*i)) & 15];
        putchar(c);
    }
}

volatile uint32_t *mprj_space = (volatile uint32_t *)0x30000000;

void main()
{
    int i, j, k;

    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oe = 1;
    reg_wb_enable = 1;
    reg_hkspi_disable = 1;

    reg_mprj_io_3 = 0x1800;
    reg_mprj_io_2 = 0x400;
    reg_mprj_io_1 = 0xc00;
    reg_mprj_io_0 = 0x1800;
    reg_mprj_xfer = 1;
    while ((reg_mprj_xfer & 0x1) == 1);

    reg_mprj_datal = 0x3;
    reg_mprj_datah = 0x0;

    print("IO readback: ");
    print_hex(reg_mprj_datah, 8);
    print(" ");
    print_hex(reg_mprj_datal, 8);
    print("\n");

    while (1) {

        print("Hello world!\n");
        // delay(800000);

        mprj_space[0] = 0xdeadbeef;
        print("Readback = ");
        print_hex(mprj_space[0], 8);
        print(" ");
        print_hex(mprj_space[1], 8);
        print("\n");

        /* reg_gpio_out = 1; // OFF
        reg_mprj_datal = 0x00000000;
        reg_mprj_datah = 0x00000000;

        delay(800000);

        reg_gpio_out = 0;  // ON
        reg_mprj_datah = 0x0000003f;
        reg_mprj_datal = 0xffffffff;

        delay(800000); */

    }


}

