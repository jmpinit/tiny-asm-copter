[Video of the project.](https://vimeo.com/110753789)

Firmware and utilities for a one-off helicopter game device that coupled an ATTiny13 to a Nokia 3310 LCD and 1 button.

Made while I was in HS for fun and for challenge. Written in assembly. 1 KB code space, 64 bytes of RAM, and 1 MHz clock.

The level gen program is a Processing sketch that outputs a source file representing a level for the game.

Some of the code might be useful to look at:

* `lib_lcd` - Shows the magic numbers needed to make the cheap 3310 LCD work. Implements software SPI.
* `lib_disphex` - Very simple printing of hexadecimal numbers in assembly code.
* `lib_eeprom` - Basic use of EEPROM.
