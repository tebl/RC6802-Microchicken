# RC6802 Microchicken

One of my most enjoyable reads the past year has been "22 micro-computer projects - to build, learn and learn" by Daniel L. Metzger, the Microchicken-computer is described in detail within it and so I sought to build one myself. The computer has been designed as a set of smaller modules, for an overall description a listing of the available modules - see the main project [README](https://github.com/tebl/RC6802-Microchicken)!

## User Interface
The User Interface module has been designed to stack on top of the CPU-module, doing it this way the overall project stays within manageable PCB-costs and should be buildable for anyone with a reasonable set of tools available. An assembled version of the CPU-module by itself as well as a version stacked underneath the User Interface module can be seen below.

![Assembled User Interface](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-11-25%2019.54.22.jpg)
![Stacked boards](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-11-25%2020.13.31.jpg)

The User Interface has two 7-segment displays as well as a 16-key keypad, all of the keypad pins have also been brought out to a separate connector so that an external keypad can also be used instead of the onboard-one (easier when using the computer with a backplane and additional expansions). It has an implementation of the described SST-circuit for the 6802 processor as well as being able to latch the IRQ-line permanently low, this is used by the monitor as a software-based alternative for stepping through code.

Additionally a circuit for loading and saving data using audio tapes is also available as an option, I only had room to add the one audio connector so I used a single 3.5mm connector instead. I used the same pinouts as on the ZX Spectrum +3, so the same tape cables can be used with the RC6802 and you should be able to find a new set of these cables via ebay as they are still being made today.

# Schematic
The supplied KiCad files should be sufficient as both a schematic and as a starting point for ordering PCBs (basically you could just zip the contents of the export folder and upload that on a fabrication site), the schematic is also available in [PDF-format](https://github.com/tebl/RC6802-Microchicken/raw/master/RC6802%20UI/export/RC6802%20UI.pdf) so that you print it out and hang it on your office wall, excellent conversation starter at any technology-oriented business worth working at (or so I keep telling myself)!

If you require more assistance, there is also a separate [Troubleshooting](https://github.com/tebl/RC6802-Microchicken/blob/master/Troubleshooting.md) guide as part of the supplied documentation. Also make sure to have a read through the [Manual](https://github.com/tebl/RC6802-Microchicken/blob/master/Manual.md) to see if it's a *feature* instead! Some of these documents may not actually exist at the time of clicking on them.


# BOM
This is the part list as it stands now, most should be easy to get a hold of from your local electronic component shop though you might have to consider other sources depending on the quality of your local vendor. Values in parenthesis are optional components that might not be needed (mainly the tape interface and the SST-circuit).

Some vendors will have the same ICs in different form factors, the ones you want will often be specified as being in the form of a DIP/PDIP package - usually you'll want sockets for each of them as well. For the pin headers, you probably won't find the exact pin count so just buy the 40 pin versions and snip off the parts you don't need.

| Reference       | Item                                  | Count |
| --------------- | ------------------------------------- | ----- |
| PCB             | Fabricate yourself using Gerber files |     1 |
| AFF1-AFF2       | 0.56" 7-segment displays (C.A.)       |     2 |
| C1-C3           | 100nF ceramic capacitor               |     3 |
| C4,C6           | 50nF ceramic capacitor                |    (2)|
| C5              | 68nF ceramic capacitor                |    (1)|
| C8              | 100nF ceramic capacitor               |    (1)|
| D1              | 5mm LED                               |    (1)|
| D2-D4           | 1N4148 small signal diode             |    (3)|
| J1 Audio        | 3.5mm 5pin green audio socket (PJ307) |    (1)|
| J2              | 2x20 straight header pins             |     1 |
| J3              | 2x5 right-angle header pins           |    (1)|
| Q1-Q2           | 2N3906 TO-92 transistor               |     2 |
| Q3-Q5           | 2N3904 TO-92 transistor               |    (3)|
| R13             | 100 ohm resistor                      |    (1)|
| R27,R29         | 220 ohm resistor                      |     2 |
| R28,R30         | 1k (1000) ohm resistor                |     2 |
| R19-R21         | 1k ohm resistor                       |    (3)|
| R14,R23         | 1k5 (1500) ohm resistor               |    (2)|
| R1-R4           | 4k7 (4700) ohm resistor               |     4 |
| R26             | 2k2 (2200) ohm resistor               |    (1)|
| R17             | 2k7 (2700) ohm resistor               |    (1)|
| R22             | 6k8 (6800) ohm resistor               |    (1)|
| R12,R18,R24     | 10k ohm resistor                      |    (3)|
| R25             | 51k ohm resistor                      |    (1)|
| SW1,SW3-SW18    | Momentary push button                 |    17 |
| SW2,SW19,SW21   | 6pin 8.5mm x 8.5mm latching switch    |    (3)|
| SW20            | 6pin 8.5mm x 8.5mm non-latching switch|    (1)|
| U1              | 74LS374 (DIP-20)                      |     1 |
| U2              | 74LS00 (DIP-14)                       |     1 |
| U3              | 74LS73 (DIP-14)                       |    (1)|