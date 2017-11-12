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

