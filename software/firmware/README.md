# Firmware
The monitor software for the RC6802 Microchicken, like the hardware design
itself is taken from the book "22 Micro-computer projects: To build, use,
and learn" by Daniel Metzger. The assembly code listed in the book has been
transcribed by me, then adapted slightly so that the code assembles as
expected in [SB-Assembler 3](https://www.sbprojects.net/sbasm/).

SB-Assembler 3 is available for all major platforms, so apart from my simple
little batch file to run it there shouldn't be any other steps necessary other
than adding it to the system PATH environment variable. If you do not wish to
alter the code, then the Intel HEX file should be suitable for flashing onto
a 28C64 EEPROM - an additional file, monitor.list makes reading the code
easier when debugging the software.