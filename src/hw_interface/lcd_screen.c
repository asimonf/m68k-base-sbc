#include "lcd_screen.h"

static volatile uint8_t *lcd_inst_reg = (uint8_t*) 0x080000; // RS = 0
static volatile uint8_t *lcd_data_reg = (uint8_t*) 0x080001; // RS = 1

static bool lcd_initialized = false;

void lcd_wait(void) {
    while (*lcd_inst_reg & 0x80); // If bit 7 is set, the lcd is busy, so we loop
}

void lcd_instr(uint8_t instruction) {
    *lcd_inst_reg = instruction;
}

void lcd_init(void) {
    if (lcd_initialized) return;

    lcd_instr(0x38); // Set 8-bit mode; 2-line display; 5x8 font
    lcd_wait();
    lcd_instr(0x0E); // Turn on display
    lcd_wait();
    lcd_instr(0x06); // Increment address by one and shift cursor
    lcd_wait();
    
    lcd_initialized = true;
}

void lcd_write_char(char c) {
    *lcd_data_reg = c;
}

void lcd_print(const char* str) {
    int i = 0;

    while (str[i] != '\0') {
        lcd_write_char(str[i++]);
        lcd_wait();
    }
}