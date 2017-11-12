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

