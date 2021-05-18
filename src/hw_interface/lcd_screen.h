#ifndef __LCD_SCREEN_H
#define __LCD_SCREEN_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

void lcd_wait(void);
void lcd_instr(uint8_t instruction);
void lcd_init(void);
void lcd_write_char(char c);
void lcd_print(const char* str);

#ifdef __cplusplus
}
#endif

#endif