TYPE=debug

OUT = out
ELF = $(OUT).elf
BIN = $(OUT).bin
MAP = $(OUT).map

LINKER_FILE = linker.ld

CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

C_SOURCES := $(wildcard *.c)
S_SOURCES := $(wildcard *.s)

H_FILES := $(wildcard *.h)

OBJDIR := obj

OBJECTS := $(patsubst %.c,%.o,$(C_SOURCES))
OBJECTS += $(patsubst %.s,%.o,$(S_SOURCES))
OBJS := $(addprefix $(OBJDIR)/, $(OBJECTS))

DEPDIR := $(OBJDIR)/.deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

DEPS := $(C_SOURCES:%.c=$(DEPDIR)/%.d)

# Specs
SPECS = nosys.specs

# Debug flags
DBGFLAGS = -g -O0

# Target settings
TARGET=STM32F446xx
FPUFLAGS = -mfpu=fpv4-sp-d16 -mfloat-abi=hard

INCFLAGS = -Icmsis_f4/Include 

# Build flags
CCFLAGS := -mcpu=cortex-m4 \
	  $(DBGFLAGS) \
	  -std=gnu11 \
	  -D$(TARGET) \
	  --specs=$(SPECS) \
	  $(FPUFLAGS) \
	  -mthumb \
	  $(INCFLAGS) \
	  -ffunction-sections \
	  -fdata-sections \
	  -nostdlib \

ASFLAGS := -mcpu=cortex-m4 \
	  $(DBGFLAGS) \
	  --specs=$(SPECS) \
	  $(FPUFLGAS) \
	  -mthumb \
          -nostdlib

# Removed -Wl,--gc-sections for testing purposes
LDFLAGS := -mcpu=cortex-m4 \
	  -T$(LINKER_FILE) \
	  --specs=$(SPECS) \
	  -Wl,-Map=$(MAP) \
	  -Wl,--print-memory-usage \
	  -static $(FPUFLAGS) \
	  -mthumb \
	  -Wl,--start-group \
	  -lc -lm \
	  -Wl,--end-group \
	  -nostdlib

ifeq ($(TYPE),debug)
	CCFLAGS += $(DBGFLAGS)
	ASFLAGS += $(DBGFLAGS)
endif

all: $(ELF) | cmsis cmsis_f4

$(OBJDIR)/%.o: %.c $(DEPDIR)/%.d | $(DEPDIR)
	$(CC) $(DEPFLAGS) $(CCFLAGS) -c -o $@ $<

$(OBJDIR)/%.o: %.s
	$(CC) $(ASFLAGS) -c -o $@ $<

$(OBJDIR):
	mkdir $@

$(DEPDIR): ; @mkdir -p $@

$(DEPS):

include $(wildcard $(DEPS))

$(OBJS): | $(OBJDIR)

$(ELF): $(DEPS) $(OBJS) $(LINKER_FILE)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
cmsis:
	git clone --depth 1 -b 5.9.0 https://github.com/ARM-software/CMSIS_5 $@

cmsis_f4:
	git clone --depth 1 https://github.com/STMicroelectronics/cmsis_device_f4 $@

.PHONY: clean
clean:
	- rm -rf $(ELF) $(BIN) $(MAP) $(DEPDIR) $(OBJDIR) 
