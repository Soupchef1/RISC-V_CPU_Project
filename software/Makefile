RV32 = riscv64-unknown-elf-
GCC = $(RV32)gcc
OBJCOPY = $(RV32)objcopy
SIZE = $(RV32)size
OBJDUMP = $(RV32)objdump
AS = $(RV32)as

OBJS = crt0.o main.o syscalls.o
EXEC = main

ARCH_FLAGS = -march=rv32i -mabi=ilp32
CFLAGS = $(ARCH_FLAGS) -O2 -g -Wall -Wextra -ffreestanding -nostdlib -mstrict-align -I.
LDFLAGS = $(ARCH_FLAGS) -T linker.ld -nostdlib -Wl,--gc-sections -lgcc

all: $(EXEC).bin $(EXEC).elf

%.o: %.c
	$(GCC) $(CFLAGS) -c $<

%.o: %.s
	$(GCC) $(CFLAGS) -c $<

$(EXEC).bin: $(EXEC).elf
	$(OBJCOPY) -O binary -R .comment -R .note -S $< $@

$(EXEC).elf: $(OBJS) linker.ld
	$(GCC) $(OBJS) $(LDFLAGS) -o $@

verilog: $(EXEC).elf
	$(OBJCOPY) -O verilog $< $(EXEC).vh

size: $(EXEC).elf
	@echo "--- Memory Layout Overview ---"
	$(SIZE) $<

boot:
	./bootload.py

disassemble: $(EXEC).elf
	$(OBJDUMP) -d $< > $(EXEC).txt

clean:
	-del /f /q *.o $(EXEC).elf $(EXEC).bin $(EXEC).txt *.hex *.vh  2>nul

	
