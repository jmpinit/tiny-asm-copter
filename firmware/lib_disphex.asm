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

