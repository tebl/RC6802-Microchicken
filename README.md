# RC6802 Microchicken

When starting out with retro computers, both fictional made homebrew or the commercial ones that were actually available for purchase in the 70s and 80s, there's one book in particular I've particularly enjoyed reading - that book is "22 micro-computer projects - to build, learn and learn" by Daniel Metzger (check out [ebay](http://ebay.com) or [abebooks.com](http://abebooks.com) for a copy). Written in 1985 on the tail-end of the homebrew computer-period, it gathers what I believe is the culmination of 10 years of teaching basic electronics, digital logic and computers to people without any prior knowledge for any of those things - perfect for me!

![22 micro-computer projects - to build, learn and learn](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-09-19%2011.49.57.jpg)

The book builds upon each chapter by building a computer based on the 6802-processor from Motorola, a mysteriously similar processor to the now far more popular 6502. While it might be seen as an odd choice for a main processor these days, even the most advanced circuits are easily adapted to the 6502 as well. Nearly every other book I've got in my bookshelf never seem to describe much past the basics, usually circuits for storage (tape-based), single-step circuits as well as using a Video Display Generator are details left for other books to fill - this is the only book I've got that actually shows how to implement them in an easy and understandable way.

The final projects in the book result in the Microchicken-computer, which I've adapted and laid out in the form of the RC6802 Microchicken computer. I have no idea why it's called the *Microchicken*, other than that the book author obviously had a peculiar sense of humour that I can't help but agree with. My current build of the computer is shown below, I also made a short [YouTube](https://www.youtube.com/watch?v=bi4SIbvGzfI)-clip where I push some of its buttons - a whole bunch of times!

![RC6802 Microchicken Computer](https://github.com/tebl/RC6802-Microchicken/raw/master/gallery/2019-11-25%2020.13.31.jpg)

## Modules
As with most of my computer builds the computer have been split into two required main boards to stay under the magic 5$ cost limits over at [PCBWay](https://www.pcbway.com/setinvite.aspx?inviteid=88707) for each, a CPU board as well as a UI board sandwiched on top. There may be additional modules found among the project files, but the ones I've added here are the ones that have been considered ready.

| Module             | RC6802 Microchicken        | Expanded system | Order |
| ------------------ | -------------------------- | --------------- | ----- |
| [CPU](https://github.com/tebl/RC6802-Microchicken/tree/master/RC6802%20CPU) | required | required | |
| [User Interface](https://github.com/tebl/RC6802-Microchicken/tree/master/RC6802%20UI) | required | required | |
| [Backplane](https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Backplane) | | required | [order](https://www.pcbway.com/project/shareproject/RC6502_Apple_1_Replica__Backplane_module_revision_A_.html?inviteid=88707) |
| [Prototyping module](https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Prototyping) | | optional | [order](https://www.pcbway.com/project/shareproject/RC6502_Apple_1_Replica__Module_prototyping_board_.html?inviteid=88707) |

As modules are constantly being worked on, I've also added an order link to the modules so that you can always get the last version I know works. Click the module name for more information about that specific module, including schematic and the list of parts you'd need to build it (BOM).