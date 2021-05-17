OUTPUT_ARCH(m68k)
SEARCH_DIR(.)
/*GROUP(-lbcc -lc -lgcc)*/
__DYNAMIC  =  0;

/*
 * Setup the memory map of the SEGA Genesis.
 * stack grows down from high memory.
 *
 * The memory map look like this:
 * +--------------------+ <- low memory
 * | .text              |
 * |        _etext      |
 * |        ctor list   | the ctor and dtor lists are for
 * |        dtor list   | C++ support
 * +--------------------+
 * .                    .
 * .                    .
 * .                    .
 * +--------------------+ <- 0x00FF0000
 * | .data              | initialized data goes here
 * |        _data       | 
 * |        _edata      |
 * +--------------------+
 * | .bss               |
 * |        _bstart     | start of bss, cleared by crt0
 * |        _bend       | start of heap, used by sbrk()
 * +--------------------+
 * .                    .
 * .                    .
 * .                    .
 * |        __stack     | top of stack
 * +--------------------+ <- 0x01000000
 */
MEMORY
{
	rom : ORIGIN = 0, LENGTH = 512K
	ram : ORIGIN = 0x00FF0000, LENGTH = 0x00010000
}

_fstack = ORIGIN(ram) + LENGTH(ram);

/*
 * allocate the stack to be at the top of memory, since the stack
 * grows down
 */

PROVIDE (__stack = _fstack);

SECTIONS
{
  .text :
  {
    /* Vector table */
    *(.isr_vector)
    *(.text .text.*)
    . = ALIGN(0x4);
    
    /* Make this a zero-terminated list of pointers to a function */
    __CTOR_LIST__ = .;
    LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
    *(.ctors)
    LONG(0)
    __CTOR_END__ = .;
    
    /* Make this a zero-terminated list of pointers to a function */
    __DTOR_LIST__ = .;
    LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
    *(.dtors)
    LONG(0)
    __DTOR_END__ = .;

    *(.rodata .rodata.*)
    *(.gcc_except_table .gcc_except_table.*)

    . = ALIGN(0x4);
    *(.init)
    *(.fini)
    _etext = .;
    *(.lit)
  } > rom

  _la_data = LOADADDR(.data);
  _data_size = SIZEOF(.data);

  .data :
  {
    _sdata = .;
    *(.got.plt) *(.got) 
    *(.shdata)
    *(.data .data.*)
    . = ALIGN(2);
    _edata = .;
  } > ram AT> rom

  _bss_size = SIZEOF(.bss);

  .bss :
  {
    _sbss = . ;
    __bss_start__ = _sbss;
    *(.shbss)
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
	  _ebss = .;
    __bss_end__ = _ebss;
    end = . ;
    __end__ = .;
  } > ram

  .stab 0 (NOLOAD) :
  {
    *(.stab)
  }

  .stabstr 0 (NOLOAD) :
  {
    *(.stabstr)
  }

  .eh_frame 0 (NOLOAD) :
  {
    *(.eh_frame)
  } 
}
