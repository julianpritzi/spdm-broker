SECTIONS
{
   .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _sstack = .;

        KEEP(*(.stack_buffer))

        . = ALIGN(8);
        _estack = .;
    } > ram

    .text :
    {
        . = ALIGN(4);
        _stext = .;
        KEEP(*(.start));
        KEEP(*(.trap_vectored));
        KEEP(*(.trap));

        *(.text .text.*)

        _srodata = .;
        *(.rodata .rodata.*)
    } > rom

    /* Mark the end of static elements */
    . = ALIGN(4);
    _erodata = .;
    _etext = .;

    .relocate :
    {
        . = ALIGN(4);
        _srelocate = .;

        PROVIDE(__global_pointer$ = . + 0x800);

        *(.ramfunc .ramfunc.*);
        *(.sdata .sdata.*)
        *(.data .data.*);

        . = ALIGN(4);
        _erelocate = .;
    } > ram AT>rom


    .sram (NOLOAD) :
    {
        . = ALIGN(4);
        _szero = .;

        *(.sbss .sbss.* .bss .bss.*);
        *(COMMON)

        . = ALIGN(4);
        _ezero = .;
    } > ram

    .heap (NOLOAD) :
    {
        . = ALIGN(8);
        _sheap = .;

        . = ORIGIN(ram) + LENGTH(ram) - 0x10;
        
        . = ALIGN(8);
        _eheap = .;
    } > ram

    /DISCARD/ :
    {
      *(.eh_frame);
    }
}

ASSERT((_etext-_stext) + (_erelocate-_srelocate) < LENGTH(rom), "Text plus relocations exceed available ROM space.");