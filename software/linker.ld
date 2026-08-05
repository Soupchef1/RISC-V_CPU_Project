MEMORY
{
  INSTRUCTION (rx)  : ORIGIN = 0x00000000, LENGTH = 64M
  STACK       (rw)  : ORIGIN = 0x04000000, LENGTH = 4M
  HEAP        (rw)  : ORIGIN = 0x04400000, LENGTH = 188M
  VIDEO_FB2   (rw)  : ORIGIN = 0x0F800000, LENGTH = 4M
  VIDEO_FB1   (rw)  : ORIGIN = 0x0FC00000, LENGTH = 4M
}

SECTIONS
{
  .text :
  {
    . = ALIGN(4);
    KEEP(*(.init))     
    *(.text .text.*)
    *(.rodata .rodata.*)
    . = ALIGN(4);
  } > INSTRUCTION

  .data :
  {
    . = ALIGN(4);
    __global_pointer$ = . + 0x800;
    *(.data .data.*)
    *(.sdata .sdata.*)
  } > STACK

  .bss :
  {
    . = ALIGN(4);
    __bss_start = .;
    *(.bss .bss.*)
    *(.sbss .sbss.*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > STACK

  __stack_top = ORIGIN(STACK) + LENGTH(STACK); /* 0x04400000 */
  __stack_low = ORIGIN(STACK);                 /* 0x04000000 */

  __heap_start = ORIGIN(HEAP);                 /* 0x04400000 */
  __heap_end   = ORIGIN(HEAP) + LENGTH(HEAP);   /* 0x0F800000 */

  __frame_buffer_2 = ORIGIN(VIDEO_FB2);        /* 0x0F800000 */
  __frame_buffer_1 = ORIGIN(VIDEO_FB1);        /* 0x0FC00000 */
}
