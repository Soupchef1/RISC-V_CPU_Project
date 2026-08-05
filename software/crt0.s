.section .init
.global _start
.type _start, @function

_start:
    /* Set up global optimization pointer */
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    /* Establish Stack Base Pointer (Grows Downward from 0x04400000) */
    la sp, __stack_top

    /* Zero-initialize the uninitialized data segment (.bss) */
    la t0, __bss_start
    la t1, __bss_end
bss_clear_loop:
    bge t0, t1, jump_to_main
    sw zero, 0(t0)
    addi t0, t0, 4
    j bss_clear_loop

jump_to_main:
    /* Call user execution space */
    jal b_main

    /* Core trap loop (Replaces 'wfi' to stay strictly within RV32I) */
core_halt:
    j core_halt
