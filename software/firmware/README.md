# Firmware
The monitor software for the RC6802 Microchicken, like the hardware design itself - it is taken from the book "22 Micro-computer projects: To build, use, and learn" by the late Daniel Metzger. The assembly code listed in the book has been transcribed by me, then adapted slightly so that the code assembles as expected when using [SB-Assembler 3](https://www.sbprojects.net/sbasm/).

SB-Assembler 3 is available for all major platforms, so apart from my simple little batch file to run it there shouldn't be any other steps necessary other than adding it to the system PATH environment variable. If you do not wish to alter the code, then the Intel HEX file should be suitable for flashing onto a 28C64 EEPROM - an additional file, monitor.list makes reading the code easier when debugging the software. The batch file is just there because I'm too lazy to type the command, so I'll just click it instead. Essentially what it does is this:
```
sbasm.py monitor.asm
```

## MICROCHICKEN 6802 MONITOR
Microchicken 6802 Monitor is copyright 1984 by the late Daniel L. Metzger, and as already mentioned I've reproduced the listing from his book in the hope that it again ends up teaching someone, something, someday.

The Microchicken monitor is a simple operating system for the 6802 microcomputer, it permits commands and data to be input to the computer via the hex keyboard (either directly on the UI module or via an external keypad). Data is displayed on two 7-segment displays found on the UI-module, the monitor contains a lookup table used when translating from binary hex digits into the corresponding display segments.

Pressing the *RESET*-button causes the program to start scanning the keyboard for the function (*FCN*) to be performed, any subsequent key entries access new functions according to the key pressed. Read the description for each function for a description of what to do from there, hit *RESET* again to exit out of the function.

**NB!** The *RESET* button is resetting the CPU, so just press and release *RESET* - then press a digit to enter the function as described below.

### (FCN-0) Set address
Enter address using keypad, 4 key inputs - address entered will be shown on the display. Both bytes, HI and LO will be flashed briefly on the displays followed by a blanking period when all digits of the address has been entered.

### (FCN-1) Display address
Displays data, 2 digits, of the currently set address on the first press. The address will automatically be incremented on subsequented presses of the *1*-key, allowing you to step through and verify a program you've keyed in before running it.

### (FCN-2) Set data
Displays data stored in currently set address on first press. New data (2 digits) is then entered via the hex keypad, the address is automatically incremented on subsequent pairs of keystrokes. Use *RESET* to stop entering data.

### (FCN-3) Display data
Displays data stored in currently set address on the first press. Subsequent presses of the *3* decrements the currently set address and displays the data stored there instead - this allows you to verify entered using FCN-2 in reverse order. Alternatively you could set the address to the start of your program using FCN-0 and then stepping through the data using FCN-1.

### (FCN-4) Run program
Executes the program starting at the currently set address.

### (FCN-5) Run from start
Computer will jump to address $0001, the then it will start executing instructions from there.

### (FCN-6) Burn EPROM
The book the that describes the Microchicken computer also include instructions for building a simple EPROM burner for 2716 EPROMs. This part of the hardware may be added in a future revision, or stripped out entirely because I wanted the function number for something else.

The function expects the RAM address of where the data to be written starts, this is as commonly expected stored with HI address $7A and LO at $7B. Data end address will likewise have to be put in addresses $7C/$7E. The address of where to start within the EPROM must be set up in addresses $7E/$7F. Takes 50ms per byte to run, displays ROM low address while programming followed by RAM end address when done - displays bad EPROM adress if data verification fails.

### (FCN-7) Dump EPROM
Dump contents of EPROM connected to the EPROM-burner part of the Microchicken, if you have this expansion for it (and you probably designed and built it yourself). See FCN-6 for more information.

RAM start address must be stored at $7A (HI)/$7B (LO), RAM end address at $7C/$7D. ROM start address at $7E/$7F.

### (FCN-8) Save RAM to TAPE
Saves RAM to tape using the tape interface included on the UI-module, this version of the hardware uses a single 3.5mm jack for both the EAR (data from tape to computer) and MIC (data from computer to tape) and uses the same cable used with the ZX Spectrum +3 as those are still being produced.

The tape interface will output one bit at a time, generating a 18 cycles with 3600Hz tone for a 0 or 9 cycles for a 1 done in an 8ms field. Note that this is dependent on the CPU speed and these values correspond to a default system clock running at around 1Mhz.   

Store starting address in RAM address $7A (HI) and $7B (LO), ending address at $7C/$7D. Takes 64ms per byte; 16 seconds per page. RAM end address will be displayed when done. Note that when loading data from tape, you'll need to know the length of the program in bytes as a the code does not write something akin to a program header to the tape.

### (FCN-9) Load data from TAPE
See FCN-8 for more details on the hardware-side of things. Store starting address in RAM address $7A (HI) and $7B (LO), ending address at $7C/$7D. The last address will be shown on the display when the program has read the specified number of bytes.

### (FCN-A) Display accumulator A
Displays the contents of accumulator A. Used after single-stepping code using the HW SST circuit.

### (FCN-B) Display accumulator B
Displays the contents of accumulator B. Used after single-stepping code using the HW SST circuit.

### (FCN-C) Display condition-code register
Displays the contents of the condition-code register, used after single-stepping code with the HW SST circuit. The register display bits are setup as following (see 6800 documentation for further details):

| bit | 7 | 6 |       5        |         4          |       3      |     2    |       1      |     0     |
| --- | - | - | -------------- | ------------------ | ------------ | -------- | ------------ | --------- |
|     | - | - | **H**alf-carry | **I**nterrupt mask | **N**egative | **Z**ero | o**V**erflow | **C**arry |

### (FCN-D) Display index register (X)
Displays the contents of the 16bit index register (X), used after single-stepping code with the HW SST circuit. HI and LO bytes will be flashed on displays, with a short pause before repeating.

### (FCN-E) Display program counter
Displays the contents of the 16bit program counter (PC), used after single-stepping code with the HW SST circuit this will show the address of the next instruction. HI and LO bytes will be flashed on displays, with a short pause before repeating.

### (FCN-F) Execute a single instruction
This function will execute a single instruction at the currently set address, performing the following steps:
1) Save the byte preceeding the user instruction, inserting a clear interrupt in its place.
2) Jumps to the "CLI" instruction. One user instruction will execute before IRQ is recognized, the IRQ handler will save all machine registers on stack and then go to *RETURN*.
3) Pull machine registers off stack, save contents in RAM buffers.
4) Replace inserted *CLI* instruction with the one overwritten in step 1.
5) Update program counter (PC) to point to the current address (ready for next step).