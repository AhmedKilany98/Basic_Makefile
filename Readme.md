# My MakeFile Basics
## How can I make it work?
* Put all your project file in one folder with makefile then open your *cmd terminal* in this folder then hit `Make` 
## I add just some of Make targets
* use `Make All` or `Make` to generate all project file like `.hex` `.elf` `.o` `.s` `.lss` `.sym` `.d`
* use `make clean` Clean out built project files.
* use `make gccversion` to generate avr-gcc version. 
* use `make size` to generate memory usage of your `.elf` file.
* use `make filename.s` to compile filename.c into the assembler code only.
* use `make filename.i` to Create a preprocessed source file for use in submitting bug reports to the GCC project.
* ### Future Work
* use `make program` Download the hex file to the device, using avrdude.
* use `make debug`  Start either simulavr or avarice as specified for debugging, with avr-gdb or avr-insight as the front end for debugging.

## Some Varabile must change before work ##
 1. MCU=? Microcontroller Name like `MCU=Atmega32`
 2. F_CPU=? Processor frequency like `F_CPU = 16000000`
 3. FORMAT=? Hex File format like `FORMAT = ihex`
 4. TARGET=? Target(Main file) file name (without extension) like ```TARGET = main```
 5. C_SRC=? List C source files here like
    ```
    C_SRC += main.c
	C_SRC += GPIO_program.c
	C_SRC += LCD_program.c
    ```
6. ASS_SRC=? List Assembler source files here.
### Additional variables are documented in Makefile.

# Referneces:
* GCC Make [documentation](https://www.gnu.org/software/make/manual/make.html)
* Moatasem El Sayed [Videos](https://bit.ly/3RHd0cS)
* Abdallah Ali Abdallah [videos](https://bit.ly/3zjGFS9)