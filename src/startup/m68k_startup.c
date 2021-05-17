#include <stdint.h>

//prototype of main

int main(void);
void __std_startup (void);
void __std_cleanup (void);

extern uint32_t _la_data;
extern uint32_t _sdata;
extern uint32_t _edata;

extern uint32_t _bss_size;
extern uint32_t _sbss;
extern uint32_t _ebss;

void _reset_handler(void) {
    uint8_t *pDst = (uint8_t*)&_sdata; //sram
	uint8_t *pSrc = (uint8_t*)&_la_data; //flash
    uint32_t size = (uint32_t)&_edata - (uint32_t)&_sdata;
	
	for (uint32_t i =0 ; i < size ; i++) {
		*pDst++ = *pSrc++;
	}

    //Init. the .bss section to zero in SRAM
	pDst = (uint8_t*)&_sbss;
    size = (uint32_t)&_ebss - (uint32_t)&_sbss;

	for(uint32_t i =0 ; i < size ; i++)
	{
		*pDst++ = 0;
	}

    // TODO: Any additional HW init required for the board

    __std_startup();
    main();
    __std_cleanup();

    while (1);
}