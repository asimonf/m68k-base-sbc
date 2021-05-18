#include "hw_interface/lcd_screen.h"

int main(void) {
    lcd_init();
    lcd_print("Hello World!");

    return 0;
}