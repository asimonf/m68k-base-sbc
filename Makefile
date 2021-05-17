PROJ_NAME ?= output

TARGET_EXEC ?= $(PROJ_NAME).elf
TARGET_HEX  ?= $(PROJ_NAME).hex
TARGET_BIN  ?= $(PROJ_NAME).bin
TARGET_MAP  ?= $(PROJ_NAME).map
TARGET_ASS  ?= $(PROJ_NAME).S

TOOL_PREFIX := m68k-unknown-elf
AS := ~/x-tools/$(TOOL_PREFIX)/bin/$(TOOL_PREFIX)-as
CC := ~/x-tools/$(TOOL_PREFIX)/bin/$(TOOL_PREFIX)-cc
CXX := ~/x-tools/$(TOOL_PREFIX)/bin/$(TOOL_PREFIX)-c++
OBJCOPY := ~/x-tools/$(TOOL_PREFIX)/bin/$(TOOL_PREFIX)-objcopy
OBJDUMP := ~/x-tools/$(TOOL_PREFIX)/bin/$(TOOL_PREFIX)-objdump

MACH := 68000

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP

ASFLAGS = -m$(MACH) --register-prefix-optional
CFLAGS = -fomit-frame-pointer -mcpu=$(MACH) -std=gnu17 -Wall -O1
CXXFLAGS = -fno-exceptions -nostartfiles -ffreestanding -fno-rtti -mcpu=$(MACH) -std=gnu++17 -O1 -Wall
LDFLAGS = -mcpu=$(MACH) -lstdc++ -lc -lgcc -lnosys -T m68k_ls.ld -Wl,-Map=$(BUILD_DIR)/$(TARGET_MAP) -nostdlib -ffreestanding -fno-rtti

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
	$(OBJCOPY) -O ihex $(BUILD_DIR)/$(TARGET_EXEC) $(BUILD_DIR)/$(TARGET_HEX)
	$(OBJCOPY) -O binary $(BUILD_DIR)/$(TARGET_EXEC) $(BUILD_DIR)/$(TARGET_BIN)
	$(OBJDUMP) -dC $(BUILD_DIR)/$(TARGET_EXEC) > $(BUILD_DIR)/$(TARGET_ASS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
