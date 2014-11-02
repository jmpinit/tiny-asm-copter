;INPUT: ZL ascii character code
;DESTROYS: r16, r17, Z
lcd_put_char:
	clr		ZH					;multiply by 6
	mov		r16, YL
	mov		r17, YH
	movw	Y, Z
	add		ZL, YL
	adc		ZH, YH
	add		ZL, YL
	adc		ZH, YH
	add		ZL, YL
	adc		ZH, YH
	add		ZL, YL
	adc		ZH, YH
	add		ZL, YL
	adc		ZH, YH
	mov		YL, r16
	mov		YH, r17

	mov		r16, ZL				;add to offset
	mov		r17, ZH
	ldi		ZL, low(font<<1)
	ldi		ZH, high(font<<1)
	add		ZL, r16
	ldi		r16, 0
	adc		ZH, r16
	add		ZH, r17

;INPUT: Z address of char image
;DESTROYS: Z
lcd_draw_char:
	lpm		r16, Z+			;first byte
	rcall	lcd_write_data
	lpm		r16, Z+			;second byte
	rcall	lcd_write_data
	lpm		r16, Z+			;third byte
	rcall	lcd_write_data
	lpm		r16, Z+			;fourth byte
	rcall	lcd_write_data
	lpm		r16, Z+			;fifth byte
	rcall	lcd_write_data
	lpm		r16, Z+			;sixth byte
	rcall	lcd_write_data

	ret

;INPUT: Z contains number
put_hex:
	movw	Y, Z

	andi	ZH, $F0	;put high nibble of 2nd byte
	lsr		ZH
	lsr		ZH
	lsr		ZH
	lsr		ZH
	mov		ZL, ZH
	rcall	lcd_put_char

	movw	Z, Y	;put low nibble of 2nd byte
	andi	ZH, $0F
	mov		ZL, ZH
	rcall	lcd_put_char

	movw	Z, Y
	andi	ZL, $F0	;put high nibble of 1st byte
	lsr		ZL
	lsr		ZL
	lsr		ZL
	lsr		ZL
	rcall	lcd_put_char

	movw	Z, Y	;put low nibble of 1st byte
	andi	ZL, $0F
	rcall	lcd_put_char
	
	ret

/*
Copyright (c) 2011 Owen Trueblood

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
