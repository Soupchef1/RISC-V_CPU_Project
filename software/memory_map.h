#ifndef MEMORY_MAP_H
#define MEMORY_MAP_H

#include <stdint.h>

/* Linker Exported Video Buffer Anchors */
extern uint32_t __frame_buffer_1[];
extern uint32_t __frame_buffer_2[];

#define FRAME_BUFFER_1_ADDR ((uint32_t*)&__frame_buffer_1)
#define FRAME_BUFFER_2_ADDR ((uint32_t*)&__frame_buffer_2)

/* Memory Mapped I/O Space (Bits [31:28] != 0) */
#define IO_BASE_ADDRESS      0x10000000

/* Hardware VDMA Buffer Change Toggle Register */
#define REG_BUFFER_CHANGE    (*(volatile uint32_t*)(IO_BASE_ADDRESS + 0x00000000))

/**
 * Triggers the hardware VDMA engine to instantly switch 
 * active scanning target to the opposing frame buffer.
 */
static inline void switch_video_buffer(void) {
    REG_BUFFER_CHANGE = 1;
}

#endif /* MEMORY_MAP_H */
