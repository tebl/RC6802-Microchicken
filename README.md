# RC6802 Microchicken

When starting out with retro computers, both fictional made homebrew or the commercial ones that were actually available for purchase in the 70s and 80s, there's one book in particular I've particularly enjoyed reading - that book is "22 micro-computer projects - to build, learn and learn" by Daniel Metzger (check out [ebay](http://ebay.com) or [abebooks.com](http://abebooks.com) for a copy). Written in 1985 on the tail-end of the homebrew computer-period, it gathers what I believe is the culmination of 10 years of teaching basic electronics, digital logic and computers to people without any prior knowledge for any of those things - perfect for me!

![22 micro-computer projects - to build, learn and learn](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-09-19%2011.49.57.jpg)

The book builds upon each chapter by building a computer based on the 6802-processor from Motorola, a mysteriously similar processor to the now far more popular 6502. While it might be seen as an odd choice for a main processor these days, even the most advanced circuits are easily adapted to the 6502 as well. Nearly every other book I've got in my bookshelf never seem to describe much past the basics, usually circuits for storage (tape-based), single-step circuits as well as using a Video Display Generator are details left for other books to fill - this is the only book I've got that actually shows how to implement them in an easy and understandable way.

The final projects in the book result in the Microchicken computer, which I've adapted and laid out in the form of the RC6802 Microchicken computer.

## Modules
As with most of my computer builds the computer have been split into two  required main boards to stay under the magic 5$ cost limits over at [PCBWay](https://www.pcbway.com/setinvite.aspx?inviteid=88707) for each, a CPU board as well as a UI board sandwiched on top. Optional boards providing added functionality may be added over time, but given the similarities with the 6502-processor you may find that several of the boards designed for the [RC6502 Apple1 Replica](https://github.com/tebl/RC6502-Apple-1-Replica) as well as the RC-ONE may also work with this one (with minor changes).

A direct order-URL may have been added to the modules, this should take you directly to the relevant [PCBWay](https://www.pcbway.com/setinvite.aspx?inviteid=88707) order page to make things easier for newly minted computer builders. Click the module name for more details for each one, this is where you'll find the schematic and BOM (list of parts needed for each one).
- [CPU](https://github.com/tebl/RC6802-Microchicken/tree/master/RC6802%20CPU)
- [User Interface](https://github.com/tebl/RC6802-Microchicken/tree/master/RC6802%20UI)

Optional modules:
- [Backplane](https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Backplane) ([order](https://www.pcbway.com/project/shareproject/RC6502_Apple_1_Replica__Backplane_module_revision_A_.html?inviteid=88707))
- [Prototyping module](https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Prototyping) ([order](https://www.pcbway.com/project/shareproject/RC6502_Apple_1_Replica__Module_prototyping_board_.html?inviteid=88707))