OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

ENTRY(_start)
SECTIONS
{
    . = %KERNEL_BASE% + %KERNEL_LOAD_OFFSET%;

    _start = .;

    /* text/read-only data */
    /* set the load address to physical MEMBASE */
    .text : AT(%MEMBASE% + %KERNEL_LOAD_OFFSET%) {
        __code_start = .;
        KEEP(*(.text.boot.vectab1))
        KEEP(*(.text.boot.vectab2))
        KEEP(*(.text.boot))
        KEEP(*(.text.boot.vectab))
        *(.text* .sram.text.glue_7* .gnu.linkonce.t.*)
    }

    .interp : { *(.interp) }
    .hash : { *(.hash) }
    .dynsym : { *(.dynsym) }
    .dynstr : { *(.dynstr) }
    .rel.text : { *(.rel.text) *(.rel.gnu.linkonce.t*) }
    .rela.text : { *(.rela.text) *(.rela.gnu.linkonce.t*) }
    .rel.data : { *(.rel.data) *(.rel.gnu.linkonce.d*) }
    .rela.data : { *(.rela.data) *(.rela.gnu.linkonce.d*) }
    .rel.rodata : { *(.rel.rodata) *(.rel.gnu.linkonce.r*) }
    .rela.rodata : { *(.rela.rodata) *(.rela.gnu.linkonce.r*) }
    .rel.got : { *(.rel.got) }
    .rela.got : { *(.rela.got) }
    .rel.ctors : { *(.rel.ctors) }
    .rela.ctors : { *(.rela.ctors) }
    .rel.dtors : { *(.rel.dtors) }
    .rela.dtors : { *(.rela.dtors) }
    .rel.init : { *(.rel.init) }
    .rela.init : { *(.rela.init) }
    .rel.fini : { *(.rel.fini) }
    .rela.fini : { *(.rela.fini) }
    .rel.bss : { *(.rel.bss) }
    .rela.bss : { *(.rela.bss) }
    .rel.plt : { *(.rel.plt) }
    .rela.plt : { *(.rela.plt) }
    .init : { *(.init) } =0x9090
    .plt : { *(.plt) }

    /* .ARM.exidx is sorted, so has to go in its own output section.  */
    __exidx_start = .;
    .ARM.exidx : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) }
    __exidx_end = .;

    .rodata : ALIGN(4) {
        __rodata_start = .;
        __fault_handler_table_start = .;
        KEEP(*(.rodata.fault_handler_table))
        __fault_handler_table_end = .;
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    .data : ALIGN(4) {
        __rodata_end = .;
        /* writable data  */
        __data_start_rom = .;
        /* in one segment binaries, the rom data address is on top of the ram data address */
        __data_start = .;
        *(.data .data.* .gnu.linkonce.d.*)
    }

    .ctors : ALIGN(4) {
        __ctor_list = .;
        KEEP(*(.ctors .init_array))
        __ctor_end = .;
    }
    .dtors : ALIGN(4) {
        __dtor_list = .;
        KEEP(*(.dtors .fini_array))
        __dtor_end = .;
    }
    .got : { *(.got.plt) *(.got) }
    .dynamic : { *(.dynamic) }

    /* unintialized data (in same segment as writable data) */
    .bss : ALIGN(4) {
        __data_end = .;
        __bss_start = .;
        KEEP(*(.bss.prebss.*))
        . = ALIGN(4);
        __post_prebss_bss_start = .;
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    }

    _end = .;

    . = %KERNEL_BASE% + %KERNEL_MEMSIZE%; 
    _end_of_ram = .;

/* #ifdef WITH_HYPER_MODE */
    .my_image_section : {
        _my_section_start = .;
        . += %KERNEL_LOAD_OFFSET%;
        _my_image_start = .;
        KEEP(*(.my_image_section*))
        . = ALIGN(4096);
        _my_image_end = .;
    }
/* #endif */

    /* Strip unnecessary stuff */
    /DISCARD/ : { *(.comment .note .eh_frame) }
}
