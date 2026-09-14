PICO_TOOLCHAIN_PATH?=~/.pico-sdk/toolchain/13_2_Rel1
CPP=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-cpp
CC=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-gcc
AS=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-as

hello.txt:
	echo "hello world!" > hello.txt

SRC=main.c second.c
OBJS=$(patsubst %.c,%.o,$(SRC))

all: firmware.elf

firmware.elf: $(OBJS)
	$(CC) -o $@ $^ --specs=nosys.specs


%.i: %.c
	$(CPP) $< > $@

%.s: %.i
	$(CC) -S $< -o $@

%.o: %.s
	$(AS) $< -o $@

.PHONY: clean all

clean:
	rm -f *.o *.i *.s firmware.elf