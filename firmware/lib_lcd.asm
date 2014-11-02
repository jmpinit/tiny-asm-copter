;INPUT: r16 data byte
;DESTROYS: r16, r17
spi_write:
	cbi		PORTB, PIN_SCLK	;lower clock
	ldi		r17, 8
spi_write0:
	sbrc	r16, 7			;write bit to pin
	sbi		PORTB, PIN_SDIN
	sbrs	r16, 7
	cbi		PORTB, PIN_SDIN

	sbi		PORTB, PIN_SCLK	;clock out bit
	cbi		PORTB, PIN_SCLK

	lsl		r16				;shift data out	

	dec		r17				;do for all bits
	brne	spi_write0

	ret

;INPUT: r16 data byte
;DESTROYS: r16, r17
lcd_write_cmd:
	cbi		PORTB, PIN_DC	;set LCD in command mode
	cbi		PORTB, PIN_SCE	;enable LCD

	rcall	spi_write		;send data

	sbi		PORTB, PIN_SCE	;disable LCD

	ret

;INPUT: r16 data byte
;DESTROYS: r16, r17
lcd_write_data:
	sbi		PORTB, PIN_DC	;set LCD in command mode
	cbi		PORTB, PIN_SCE	;enable LCD

	rcall	spi_write		;send data

	sbi		PORTB, PIN_SCE	;disable LCD

	ret

/*
Copyright (c) 2011 Owen Trueblood

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
