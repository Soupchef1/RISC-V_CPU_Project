#include <unistd.h>
#include <errno.h>
#include <stdint.h>

extern char __heap_start; 
extern char __heap_end;   

static char *current_heap_break = &__heap_start;

void* _sbrk(int incr) {
    char *previous_heap_break = current_heap_break;

    /* Check against 188MB allocation limit boundary */
    if (current_heap_break + incr > &__heap_end) {
        errno = ENOMEM;
        return (void*)-1;
    }

    current_heap_break += incr;
    return (void*)previous_heap_break;
}
