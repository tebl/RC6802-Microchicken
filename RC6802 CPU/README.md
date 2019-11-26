# RC6802 Microchicken

One of my most enjoyable reads the past year has been "22 micro-computer projects - to build, learn and learn" by Daniel L. Metzger, the Microchicken-computer is described in detail within it and so I sought to build one myself. The computer has been designed as a set of smaller modules, for an overall description a listing of the available modules - see the main project [README](https://github.com/tebl/RC6802-Microchicken).

## CPU
The CPU module has been designed to stack with the UI-board, doing it this way the overall project stays within manageable PCB-costs and should be buildable for anyone with a reasonable set of tools. An assembled version of the CPU-module by itself as well as a version stacked underneath the User Interface module can be seen below.

![Assembled CPU Board](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-11-25%2019.54.03.jpg)
![Stacked boards](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-11-25%2020.13.31.jpg)

The CPU board is actually a complete SBC (Single Board Computer) by itself, meaning that it can be used either standalone though you'd probably need to add some sort of additional hardware in order to see anything actually running. I hope to build more modules that can be used with it other than the standard User Interface. 

Some of the ICs however have been changed out with components that should be easier to source for a lot less money. For those that find themselves wondering why there are ICs with more capacity (RAM/ROM) than is actually available to the system, it's simply because they were cheaper than the smaller capacity variants and I didn't want to lay claim to more of the address space than what the original computer calls for (8K for each).

## Jumpers
| Reference | Position | Description                                        |
| --------- | -------- | -------------------------------------------------- |
| RAM_EN    | 1-2 *    | Enable on-chip 128 bytes of memory on 6802 CPU     |
|           | 2-3      | Disable on-chip memory or jumper if using 6808 CPU |
| RAM_SEL   | 1-2 *    | 8K of static RAM on addresses $C000-$DFFF          |
|           | 2-3      | 8k of static RAM on addresses $0000-$1FFF          |
| LED_EN    | 1-2 *    | Enable status LEDs                                 |
|           | 2-3      | Disable status LEDs                                |
| A14, A13  | 1-2 **   | EEPROM 8K window selection (sets line HIGH)        |
|           | 2-3 **   | EEPROM 8K window selection (sets line LOW)         |

*) Marks the default jumpered positions for a standalone RC6802 system with 6802 CPU installed.
**) A14 and A13 must be jumpered when using 28C256 EEPROM, leave unjumpered when using the lower capacity 28C64 EEPROM instead.


# Schematic
The supplied KiCad files should be sufficient as both a schematic and as a starting point for ordering PCBs (basically you could just zip the contents of the export folder and upload that on a fabrication site), the schematic is also available in [PDF-format](https://github.com/tebl/RC6802-Microchicken/raw/master/RC6802%20CPU/export/RC6802%20CPU.pdf) so that you print it out and hang it on your office wall, excellent conversation starter at any technology-oriented business worth working at (or so I keep telling myself)!

If you require more assistance, there is also a separate [Troubleshooting](https://github.com/tebl/RC6802-Microchicken/blob/master/Troubleshooting.md) guide as part of the supplied documentation. Also make sure to have a read through the [Manual](https://github.com/tebl/RC6802-Microchicken/blob/master/Manual.md) to see if it's a *feature* instead! Some of these documents may not actually exist at the time of clicking on them.


# BOM
This is the part list as it stands now, most should be easy to get a hold of from your local electronic component shop though you might have to consider other sources depending on the quality of your local vendor. Values in parenthesis are optional components that might not be needed (status LEDs and when using 28C256 EEPROMs).

Some vendors will have the same ICs in different form factors, the ones you want will often be specified as being in the form of a DIP/PDIP package - usually you'll want sockets for each of them as well. For the pin headers, you probably won't find the exact pin count so just buy the 40 pin versions and snip off the parts you don't need.

| Reference    | Item                                  | Count |
| ------------ | ------------------------------------- | ----- |
| PCB          | Fabricate yourself using Gerber files |     1 |
| C1-C8,C10    | 100nF ceramic capacitor               |     9 |
| C9,C11       | 22pF ceramic capacitor                |     2 |
| D1-D8        | 5mm LED (assorted colours)            |    (8)|
| J1           | 39p right angle pin header            |    (1)|
| J2           | 2x20 pin straight header              |     1 |
| J3           | 2.1mm x 5.5mm barrel plug             |     1 |
| J4,JP7-JP8   | Single row, 3 pin straight  header    |    (3)|
| JP2,JP3      | Single row, 3 pin straight  header    |     2 |
| R1-R4        | 3k3 (3300) ohm resistor               |     4 |
| R5-R12       | 220 ohm resistor                      |    (8)|
| U1           | MC6802 CPU (DIP-40) *                 |     1 |
| U2           | 62256 Static RAM (DIP-28)             |     1 |
| U3           | 28C64/28C256 EEPROM (DIP-28)          |     1 |
| U4           | 74LS00 (DIP-14)                       |     1 |
| U6           | MC6821 PIA (DIP-40)                   |     1 |
| U7           | 74LS138 (DIP-16)                      |     1 |
| U8           | 74LS240 (DIP-20)                      |    (1)|
| Y1           | 4Mhz crystal (HC-49)                  |     1 |
|              | Jumpers for settings (CAP headers)    |     5 |

*) You can also use an MC6808 processor, read jumpers descriptions on how to do this. The 6808 lacks the on-chip memory found on the 6802, so it needs to be jumpered as disabled with static memory moved into the lower addresses instead.

