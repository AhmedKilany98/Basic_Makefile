################################################################################
## Basic MAKEFILE ##
## Author	: Ahmed Kilany 	##
## Date		: 19/07/2022	##
## Version	: 01			##
################################################################################
#----------------------------------------------------------------------------
# Referneces:
# <1> https://www.gnu.org/software/make/manual/make.html
# <2> https://bit.ly/3RHd0cS
# <3> https://bit.ly/3zjGFS9 
#----------------------------------------------------------------------------
# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# Comming Soon < make program and debug >
# make program = Download the hex file to the device, using avrdude.
#                Please customize the avrdude settings below first!
#
# make debug = Start either simulavr or avarice as specified for debugging, 
#              with avr-gdb or avr-insight as the front end for debugging.
# Comming Soon < make program and debug >
#
# make filename.s = Just compile filename.c into the assembler code only.
#
# make filename.i = Create a preprocessed source file for use in submitting
#                   bug reports to the GCC project.
#
# To rebuild project do "make clean" then "make all".
#----------------------------------------------------------------------------

## Some Varabile ##

#MCU name
MCU = atmega32


# Processor frequency.
F_CPU = 8000000


# Output format. (can be srec, ihex, binary)
FORMAT = ihex


# Target file name (without extension).
TARGET = main

# Object files directory
#     To put object files in current directory, use a dot (.), do NOT make
#     this an empty or blank macro!
OBJDIR = .

# List C source files here. (C dependencies are automatically generated.)
C_SRC += main.c
C_SRC += GPIO_program.c
C_SRC += LCD_program.c
C_SRC += KPD_program.c
C_SRC += EEPROM_INTERNAL_program.c


# Debugging format.
#     Native formats for AVR-GCC's -g are dwarf-2 [default] or stabs.
#     AVR Studio 4.10 requires dwarf-2.
#     AVR [Extended] COFF format requires stabs, plus an avr-objcopy run.
DEBUG = dwarf-2
# List Assembler source files here.
#     Make them always end in a capital .S NOT lowercase .s.
ASS_SRC =

# Optimization level, can be [0, 1, 2, 3, s]. 
#     0 = turn off optimization. s = optimize for size.
#     (Note: 3 is not always the best optimization level. See avr-libc FAQ.)
OPT = s


# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
#     Use forward slashes for directory separators.
#     For a directory that has spaces, enclose it in quotes.
EXTRAINCDIRS = 


# Compiler flag to set the C Standard level.
#     c89   = "ANSI" C
#     gnu89 = c89 plus GCC extensions
#     c99   = ISO C99 standard (not yet fully implemented)
#     gnu99 = c99 plus GCC extensions
C_STANDARD = -std=c99


# Place -D or -U options here for C sources
C_DEFS = -DF_CPU=$(F_CPU)UL


# Place -D or -U options here for ASM sources
ASS_DEFS = -DF_CPU=$(F_CPU)

#============================================================================
#---------------- Compiler Options C ----------------
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing


C_FLAGS = -g$(DEBUG)
C_FLAGS += $(C_DEFS)
C_FLAGS += -O$(OPT)
C_FLAGS += -funsigned-char
C_FLAGS += -funsigned-bitfields
C_FLAGS += -fpack-struct
C_FLAGS += -fshort-enums
C_FLAGS += -Wall
C_FLAGS += -Wstrict-prototypes
#C_FLAGS += -mshort-calls
#C_FLAGS += -fno-unit-at-a-time
#C_FLAGS += -Wundef
#C_FLAGS += -Wunreachable-code
#C_FLAGS += -Wsign-compare
###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C_FLAGS += -Wa,-adhlns=$(<:%.c=$(OBJDIR)/%.lst)
C_FLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))
###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C_FLAGS += $(C_STANDARD)

#============================================================================
#---------------- Assembler Options ----------------
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -adhlns:   create listing
#  -gstabs:   have the assembler create line number information; note that
#             for use in COFF files, additional information about filenames
#             and function names needs to be present in the assembler source
#             files -- see avr-libc docs [FIXME: not yet described there]
#  -listing-cont-lines: Sets the maximum number of continuation lines of hex 
#       dump that will be displayed for a given single line of source input.
ASS_FLAGS = $(ASS_DEFS) -Wa,-adhlns=$(<:%.S=$(OBJDIR)/%.lst),-gstabs,--listing-cont-lines=100

#============================================================================
#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(TARGET).map,--cref
#LDFLAGS += $(EXTMEMOPTS)
###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LDFLAGS += $(patsubst %,-L%,$(EXTRALIBDIRS))
###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#LDFLAGS += $(PRINTF_LIB) $(SCANF_LIB) $(MATH_LIB)
# Used to add Linker script
#LDFLAGS += -T linker_script.x


#============================================================================
# Define programs and commands.
SHELL = cmd
CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
AR = avr-ar rcs
NM = avr-nm
AVRDUDE = avrdude
REMOVE = rm -f
REMOVEDIR = rm -rf
COPY = cp
WINSHELL = cmd

#============================================================================
# Define Messages
# English
MSG_ERRORS_NONE = ---------- Errors: none
MSG_BEGIN = ---------- begin ----------
MSG_END = ---------- end ----------
MSG_SIZE = ---------- Print Size:
MSG_FLASH = ---------- Creating load file for Flash:
MSG_EXTENDED_LISTING = ---------- Creating Extended Listing:
MSG_SYMBOL_TABLE = ---------- Creating Symbol Table:
MSG_LINKING = ---------- Linking:
MSG_COMPILING = ---------- Compiling C:
MSG_ASSEMBLING = ---------- Assembling:
MSG_CLEANING = ---------- Cleaning project:

#============================================================================
# Define all object files.
# " $(C_SRC:%.c=$(OBJDIR)/%.o) change any .c file in variable C_SRC by .o"
# " $(ASS_SRC:%.S=$(OBJDIR)/%.o) change any .S file in variable ASS_SRC by .o"
OBJ = $(C_SRC:%.c=$(OBJDIR)/%.o) $(ASS_SRC:%.S=$(OBJDIR)/%.o) 


#============================================================================
# Define all listing files.
LST = $(C_SRC:%.c=$(OBJDIR)/%.lst) $(ASS_SRC:%.S=$(OBJDIR)/%.lst) 

#============================================================================
# Compiler flags to generate dependency files.
# "-M"		:generate prerequisites of source file with system header files.
# "-MM"		:generate prerequisites of source file without system header files.
# "-MMD"	:Generate dependency information as a side-effect of compilation, not instead of compilation.
# "-MP"		:Adds a target for each prerequisite in the list, to avoid errors when deleting files.
# "-MF FN":Write the generated dependency file and FN is file name.
# EX: inCmd <avr-gcc -MM -MP -MF dep.d GPIO_program.c>
# dep.d File Out """	GPIO_program.o: GPIO_program.c GPIO_interface.h GPIO_private.h 	# 						GPIO_config.
#						GPIO_interface.h:
#						GPIO_private.h:
#						GPIO_config.h: 														"""
# "-MT TN"	:Set the name of the target in the generated dependency file and TN is target name. 
GENDEPFLAGS = -MMD -MP -MF .dep/$(@F).d

#============================================================================
# Combine all necessary flags and optional flags.
# Add target processor to flags.
# "-I." include all file in current directory
ALL_C_FLAGS = -mmcu=$(MCU) -I. $(C_FLAGS) $(GENDEPFLAGS)
ALL_ASS_FLAGS = -mmcu=$(MCU) -I. -x assembler-with-cpp $(ASFLAGS)

#============================================================================
# Default target.
#all: begin gccversion sizebefore build sizeafter end	
all: begin gccversion build size end

# Change the build target to build a HEX file or a library.
build: elf hex lss sym 
#build: lib


elf: $(TARGET).elf
hex: $(TARGET).hex
lss: $(TARGET).lss
sym: $(TARGET).sym
# to generate assembler file from main.c file
ass: $(TARGET).s

begin:
	@echo
	@echo $(MSG_BEGIN)

end:
	@echo $(MSG_END)
	@echo


# Display size of file.
HEXSIZE = $(SIZE) --target=$(FORMAT) $(TARGET).hex
ELFSIZE = $(SIZE) --mcu=$(MCU) --format=avr $(TARGET).elf

size: 
	@echo $(MSG_SIZE) $(TARGET).elf
	$(ELFSIZE)

# Display compiler version information.
gccversion:
	@echo 
	@$(CC) --version

# Create final output files (.hex, .eep) from ELF output file.
%.hex: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom -R .fuse -R .lock $< $@

# Create extended listing file from ELF output file.
%.lss: %.elf
	@echo
	@echo $(MSG_EXTENDED_LISTING) $@
	$(OBJDUMP) -h -S -z $< > $@

# Create a symbol table from ELF output file.
%.sym: %.elf
	@echo
	@echo $(MSG_SYMBOL_TABLE) $@
	$(NM) -n $< > $@

# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
%.elf: $(OBJ)
	@echo
	@echo $(MSG_LINKING) $@
	$(CC) $(ALL_C_FLAGS) $^ --output $@ $(LDFLAGS)

# Compile: create object files from C source files.
$(OBJDIR)/%.o : %.c
	@echo
	@echo $(MSG_COMPILING) $<
	$(CC) -c $(ALL_C_FLAGS) $< -o $@ 

# Compile: create assembler files from C source files.
%.s : %.c
	@echo
	@echo ---------- create assembler files from C source files.
	$(CC) -S $(ALL_C_FLAGS) $< -o $@

# Assemble: create object files from assembler source files.
$(OBJDIR)/%.o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c $(ALL_ASS_FLAGS) $< -o $@
	
# Create preprocessed source for use in sending a bug report.
%.i : %.c
	$(CC) -E -mmcu=$(MCU) -I. $(CFLAGS) $< -o $@ 
	
	
# Target: clean project.
clean: begin clean_list end

clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(TARGET).hex
	$(REMOVE) $(TARGET).elf
	$(REMOVE) $(TARGET).map
	$(REMOVE) $(TARGET).sym
	$(REMOVE) $(TARGET).S
	$(REMOVE) $(TARGET).lss
	$(REMOVE) $(C_SRC:%.c=$(OBJDIR)/%.o)
	$(REMOVE) $(C_SRC:%.c=$(OBJDIR)/%.lst)
	$(REMOVE) $(C_SRC:.c=.s)
	$(REMOVE) $(C_SRC:.c=.d)
	$(REMOVE) $(C_SRC:.c=.i)
	$(REMOVEDIR) .dep


# Create object files directory
$(shell mkdir $(OBJDIR)) 

#============================================================================
# Include the dependency files.
-include $(shell mkdir .dep)  $(wildcard .dep/*)

#============================================================================
# Listing of phony targets.
# ".PHONY" : avoid conflict between file name and target name.
.PHONY : all begin finish end size gccversion \
build elf hex lss sym \
clean clean_list
