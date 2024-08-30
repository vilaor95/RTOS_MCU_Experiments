OUT = out.elf

STMPROG = st-flash

LINKER_FILE = linker.ld

CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

C_OBJECTS = main.o
S_OBJECTS = startup.o

# Debug flags
DBGFLAGS = 

# Target settings
TARGET=STM32F446xx
FPUFLAGS = -mfpu=fpv4-sp-d16 -mfloat-abi=hard

INCFLAGS = -Icmsis_f4/Include 

# Build flags
CCFLAGS = -mcpu=cortex-m4 $(DBGFLAGS) -std=gnu11 -D$(TARGET) --specs=nano.specs $(FPUFLAGS) -mthumb $(INCFLAGS)
ASFLAGS = -mcpu=cortex-m4 $(DBGFLAGS) --specs=nano.specs $(FPUFLGAS) -mthumb
LDFLAGS = -mcpu=cortex-m4 -T$(LINKER_FILE) --specs=nosys.specs -Wl,-Map=out.map -Wl,--gc-sections -static $(FPUFLAGS) -mthumb -Wl,--start-group -lc -lm -Wl,--end-group

all: cmsis cmsis_f4 $(OUT)

%.o: %.c
	$(CC) $(CCFLAGS) -c -o $@ $<

%.o: %.s
	$(CC) $(ASFLAGS) -c -o $@ $<

$(OUT): $(C_OBJECTS) $(S_OBJECTS) $(LINKER_FILE)
	$(CC) -o $@ $(C_OBJECTS) $(S_OBJECTS) $(LDFLAGS)

.PHONY: flash
flash: $(OUT)
	$(OBJCOPY) -O binary $(OUT) out.bin
	$(STMPROG) write out.bin 0x8000000

cmsis:
	git clone --depth 1 -b 5.9.0 https://github.com/ARM-software/CMSIS_5 $@

cmsis_f4:
	git clone --depth 1 https://github.com/STMicroelectronics/cmsis_device_f4 $@

.PHONY: clean
clean:
	rm $(OUT) $(C_OBJECTS) $(S_OBJECTS)
