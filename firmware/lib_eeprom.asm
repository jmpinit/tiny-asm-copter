;INPUT: r16 address to write to, r17 data to write
eeprom_write:
	sbic	EECR, EEPE
	rjmp	eeprom_write
	out		EEARL, r16
	out		EEDR, r17
	sbi		EECR, EEMPE		;enable eeprom
	sbi		EECR, EEPE		;enable write
	ret

;INPUT: r16 address to read from
;OUTPUT:r17 data byte
eeprom_read:
	sbic	EECR, EEPE
	rjmp	eeprom_read
	out		EEARL, r16
	sbi		EECR, EERE
	in		r17, EEDR
	ret

/*
Copyright (c) 2011 Owen Trueblood

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
