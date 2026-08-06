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

    /* --- NEW: Copy .data section from ROM to RAM --- */
    la a0, __data_load_start  /* a0 = Source address in ROM */
    la a1, __data_start       /* a1 = Destination address in RAM */
    la a2, __data_end         /* a2 = End of destination */
    
data_copy_loop:
    bge a1, a2, data_copy_done /* If start >= end, skip/finish copy */
    lw t0, 0(a0)              /* Load a word from ROM */
    sw t0, 0(a1)              /* Store the word to RAM */
    addi a0, a0, 4            /* Advance source pointer by 4 bytes */
    addi a1, a1, 4            /* Advance destination pointer by 4 bytes */
    j data_copy_loop          /* Repeat */
    
data_copy_done:
    /* ----------------------------------------------- */

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
    jal main

    /* Core trap loop (Replaces 'wfi' to stay strictly within RV32I) */
core_halt:
    j core_halt