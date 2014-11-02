.include "tn13def.inc"
;.include "font.txt"
;***** Macros
.MACRO SET_POINT
	ldi		r16, $80|@0			;set column
	rcall	lcd_write_cmd
	ldi		r16, $40|(@1&$07)	;set row
	rcall	lcd_write_cmd
.ENDMACRO

.MACRO CALL_DELAY
	ldi		r16, @0
	rcall	delay
.ENDMACRO

;***** Constants

.equ	LCD_CNT		= 252
.equ	MAX_SPEED	= 5		;higher means slower (0 fastest)

;***** Registers

.def	speed		= r2

;***** Pin definitions

.equ	PIN_BUTTON	= 0		;PORTB
.equ	PIN_DC		= 1
.equ	PIN_SCE		= 2
.equ	PIN_SDIN	= 3
.equ	PIN_SCLK	= 4

.cseg
.org 0
	rjmp	reset

.include "lib_lcd.asm"
.include "lib_eeprom.asm"
.include "lib_disphex.asm"

draw_cave:
	SET_POINT	0, 0

	ldi		r19, 0		;row
	movw	Y, Z
draw_cave_row:			;row loop
	ldi		r20, 0		;column
	movw	Z, Y
draw_cave_col:			;column loop
	//load random
	lpm		r21, Z+		;height
	lpm		r22, Z+		;size
	add		r22, r21	;end

	sbi		PORTB, PIN_DC	;set LCD in command mode
	cbi		PORTB, PIN_SCE	;enable LCD
	
	//see if we are in white or black
	cp		r19, r21
	brge	draw_cave_comp
	rjmp	draw_cave_black
draw_cave_comp:
	cp		r19, r22
	brlt	draw_cave_white
draw_cave_black:
	//draw black block
	ldi		r16, $FF
	rcall	spi_write
	ldi		r16, $FF
	rcall	spi_write
	ldi		r16, $FF
	rcall	spi_write
	ldi		r16, $FF
	rcall	spi_write

	rjmp	draw_cave_loop
draw_cave_white:
	//draw white block
	ldi		r16, $00
	rcall	spi_write
	ldi		r16, $00
	rcall	spi_write
	ldi		r16, $00
	rcall	spi_write
	ldi		r16, $00
	rcall	spi_write
draw_cave_loop:
	sbi		PORTB, PIN_SCE	;disable LCD

	//loop column
	inc		r20
	ldi		r21, 21
	cp		r20, r21
	brne	draw_cave_col

	//loop row
	inc		r19
	ldi		r21, 6
	cp		r19, r21
	brne	draw_cave_row

	//set us back where we started
	subi	ZL, 42
	ldi		r21, 0
	sbc		ZH, r21

	ret

draw_heli:
	//set the LCD to center
	ldi		r16, $80|32			;set column
	rcall	lcd_write_cmd

	lds		r16, $0060			;get heli height

	andi	r16, $07			;calculate row
	ori		r16, $40
	rcall	lcd_write_cmd		;set lcd to heli height

	//draw the heli
	sbi		PORTB, PIN_DC	;set LCD in command mode
	cbi		PORTB, PIN_SCE	;enable LCD

	//this defines what the heli looks like
	ldi		r16, $18
	rcall	spi_write
	ldi		r16, $39
	rcall	spi_write
	ldi		r16, $b1
	rcall	spi_write
	ldi		r16, $49
	rcall	spi_write
	ldi		r16, $4F
	rcall	spi_write
	ldi		r16, $49
	rcall	spi_write
	ldi		r16, $49
	rcall	spi_write
	ldi		r16, $B1
	rcall	spi_write

	sbi		PORTB, PIN_SCE	;disable LCD

	ret

move_heli_up:
	lds		r16, $0060		;load heli height

	cpi		r16, 0			;don't move if heli at top
	breq	move_heli_up_no
	
	dec		r16				;raise heli
	sts		$0060, r16
move_heli_up_no:
	ret

move_heli_down:
	lds		r16, $0060		;load heli height

	cpi		r16, 5			;don't move if heli at bottom
	breq	move_heli_down_no
	
	inc		r16				;lower heli
	sts		$0060, r16
move_heli_down_no:
	ret

check_crash:
	lds		r16, $0060	;get heli height

	adiw	Z, 18		;get info about terrain at heli
	lpm		r21, Z+		;height
	lpm		r22, Z+		;size
	add		r22, r21	;end

	cp		r16, r21	;check if crashed
	brlt	die
	cp		r16, r22
	brge	die

	subi	ZL, 20		;return ptr to terrain
	ldi		r21, 0
	sbc		ZH, r21

	ret

difficulty:
	movw	Y, Z	;save Z

	rcall	remove_offset
	
	//divide distance by 16
	asr		ZH
	asr		ZL
	asr		ZH
	asr		ZL
	asr		ZH
	asr		ZL
	asr		ZH
	asr		ZL

	//subtract from slowest speed
	ldi		r16, MAX_SPEED
	sub		r16, ZL

	brcc	difficulty0
	ldi		r16, 1
difficulty0:
	inc		r16
	mov		speed, r16	;set the speed

	movw	Z, Y	;restore Z

	ret

remove_offset:
	subi	ZL, low(random_numbers<<1)	;remove offset from distance
	ldi		r21, high(random_numbers<<1)
	sbc		ZH, r21

	asr		ZH							;divide by two to get real distance
	asr		ZL

	ret

show_progress:
	movw	X, Z			;save Z	
	rcall	remove_offset

	rcall	put_hex			;display number

	movw	Z, X			;restore Z

	ret

;DESTROYS: r16, r17, r18
die:
	SET_POINT	0, 0

	subi	ZL, 20			;return ptr to terrain
	ldi		r21, 0
	sbc		ZH, r21

	ldi		r18, LCD_CNT
die0:
	ldi		r16, $AA		;write lines to screen
	rcall	lcd_write_data

	dec		r18				;count down
	brne	die0			;loop back

	ldi		r18, LCD_CNT
die1:
	ldi		r16, $AA		;write lines to screen
	rcall	lcd_write_data

	dec		r18				;count down
	brne	die1			;loop back
die_highscore:
	//load high byte of previous hiscore
	ldi		r16, $00
	rcall	eeprom_read
	mov		XH, r17

	//load low byte of previous hiscore
	ldi		r16, $01
	rcall	eeprom_read
	mov		XL, r17

	movw	Y, Z			;save Z

	rcall	remove_offset

	cp		ZL, XL			;compare the hiscores
	cpc		ZH, XH
	brlt	die_message		;no hi score :(

	movw	Z, Y
	rcall	save_score		;hi score!
die_message:
	movw	Z, Y			;restore Z

	SET_POINT	30, 3		;show how far we got in middle of screen
	rcall	show_progress

	SET_POINT	18, 2		;put an 'H' for hiscore
	ldi		ZL, 16
	rcall	lcd_put_char

	//load high byte of previous hiscore
	ldi		r16, $00
	rcall	eeprom_read
	mov		ZH, r17

	//load low byte of previous hiscore
	ldi		r16, $01
	rcall	eeprom_read
	mov		ZL, r17

	//draw the hiscore
	SET_POINT	30, 2
	rcall	put_hex

die2:
	rjmp	die2		;loop forever

;INPUT: Z contains score
save_score:
	movw	X, Z		;save Z

	rcall	remove_offset

	ldi		r16, $00	;save high byte of score
	mov		r17, ZH
	rcall	eeprom_write

	ldi		r16, $01	;save low byte of score
	mov		r17, ZL
	rcall	eeprom_write

	movw	Z, X		;restore Z

	ret

init_hiscores:
	//read spot where hiscore is stored
	ldi		r16, $00
	rcall	eeprom_read
	cpi		r17, $FF
	brne	init_hiscores1
	ldi		r16, $01
	rcall	eeprom_read

	cpi		r17, $FF		;if hiscore intialized
	brne	init_hiscores1	;don't initialize hiscore

	//otherwise initialize high score
	ldi		r16, $00
	ldi		r17, $00
	rcall	eeprom_write
	ldi		r16, $01
	ldi		r17, $00
	rcall	eeprom_write
init_hiscores1:
	ret

;INPUT: r16 time
;DESTROYS: r0, r1, r2
delay:
	clr		r0
	clr		r1
delay0: 
	dec		r0
	brne	delay0
	dec		r1
	brne	delay0
	dec		r16
	brne	delay0
	ret

;***** Program Execution Starts Here

reset:
	//set LCD pins to output
	sbi		DDRB, PIN_DC
	sbi		DDRB, PIN_SCE
	sbi		DDRB, PIN_SDIN
	sbi		DDRB, PIN_SCLK
	
	//initialize LCD
	//these values are from the 3310 datasheet
	ldi		r16, 0x21
	rcall	lcd_write_cmd

	ldi		r16, 0xD0
	rcall	lcd_write_cmd

	ldi		r16, 0x04
	rcall	lcd_write_cmd

	ldi		r16, 0x13
	rcall	lcd_write_cmd

	ldi		r16, 0x20
	rcall	lcd_write_cmd

	ldi		r16, 0x0C
	rcall	lcd_write_cmd

	//initialize eeprom for hiscores if first run
	rcall	init_hiscores

	//initialize terrain pointer
	ldi		ZL, low(random_numbers<<1)
	ldi		ZH, high(random_numbers<<1)

	//heli initial height
	ldi		r16, 3
	sts		$0060, r16

	//initialize speed
	rcall	difficulty

forever:
	rcall	draw_cave

	//handle button presses
	in		r16, PINB
	sbrc	r16, PIN_BUTTON
	rcall	move_heli_down

	in		r16, PINB
	sbrs	r16, PIN_BUTTON
	rcall	move_heli_up

	rcall	draw_heli

	rcall	check_crash		;die if heli crashed

	//show progress in upper left corner
	SET_POINT	0, 0
	rcall	show_progress

	rcall	difficulty		;gets harder (faster) the further you get
	
	adiw	Z, 2			;move heli forward in terrain

	mov		r16, speed		;delay corresponding to speed
	rcall	delay

	rjmp	forever			;do it until they die! muahaha

.include "random.asm"
.include "font_heli.asm"

/*
Copyright (c) 2011 Owen Trueblood

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
