OUT = out
ELF = $(OUT).elf
BIN = $(OUT).bin

STMPROG = st-flash

LINKER_FILE = linker.ld

CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

C_OBJECTS = main.o
S_OBJECTS = startup.o

# Specs
SPECS = nosys.specs

# Debug flags
DBGFLAGS = 

# Target settings
TARGET=STM32F446xx
FPUFLAGS = -mfpu=fpv4-sp-d16 -mfloat-abi=hard

INCFLAGS = -Icmsis_f4/Include 

# Build flags
CCFLAGS = -mcpu=cortex-m4 \
	  $(DBGFLAGS) \
	  -std=gnu11 \
	  -D$(TARGET) \
	  --specs=$(SPECS) \
	  $(FPUFLAGS) \
	  -mthumb \
	  $(INCFLAGS) \
	  -ffunction-sections \
	  -fdata-sections
	  #-nostdlib

ASFLAGS = -mcpu=cortex-m4 \
	  $(DBGFLAGS) \
	  --specs=$(SPECS) \
	  $(FPUFLGAS) \
	  -mthumb

LDFLAGS = -mcpu=cortex-m4 \
	  -T$(LINKER_FILE) \
	  --specs=$(SPECS) \
	  -Wl,-Map=out.map \
	  -Wl,--gc-sections \
	  -static $(FPUFLAGS) \
	  -mthumb \
	  -Wl,--start-group \
	  -lc -lm \
	  -Wl,--end-group

all: cmsis cmsis_f4 $(ELF)

%.o: %.c
	$(CC) $(CCFLAGS) -c -o $@ $<

%.o: %.s
	$(CC) $(ASFLAGS) -c -o $@ $<

$(ELF): $(C_OBJECTS) $(S_OBJECTS) $(LINKER_FILE)
	$(CC) -o $@ $(C_OBJECTS) $(S_OBJECTS) $(LDFLAGS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
.PHONY: flash
flash: $(BIN)
	$(STMPROG) write $< 0x8000000

cmsis:
	git clone --depth 1 -b 5.9.0 https://github.com/ARM-software/CMSIS_5 $@

cmsis_f4:
	git clone --depth 1 https://github.com/STMicroelectronics/cmsis_device_f4 $@

.PHONY: clean
clean:
	- rm $(ELF) $(BIN) $(C_OBJECTS) $(S_OBJECTS)
