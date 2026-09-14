all: firmware.elf

hello.txt:
	echo "hello world!" > hello.txt

PICO_TOOLCHAIN_PATH?=~/.pico-sdk/toolchain/13_2_Rel1
CPP=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-cpp
CC=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-gcc
AS=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-as

SRC=main.c second.c
OBJS=$(patsubst %.c,%.o,$(SRC))

firmware.elf: $(OBJS)
	$(CC) -o $@ $^ --specs=nosys.specs

%.i: %.c
	$(CPP) $< > $@

%.s: %.i
	$(CC) -S $< -o $@

%.o: %.c
	$(CPP) $< > $*.i
	$(CC) -S $*.i -o $*.s
	$(AS) $*.s -o $@

.PHONY: clean all

clean:
	rm -f *.o *.i *.s firmware.elf