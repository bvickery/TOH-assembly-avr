.def XH = r27
.def XL = r26
.def YH = r29
.def YL = r28
.def ZH = r31
.def ZL = r30
.equ SPH=0x5E
.equ SPL=0x5D

.cseg
.org 0x70
	ldi XH, high(disks)
	ldi XL, low(disks)
	ldi r16, 0x05
	ldi r17, 0x00
	st X+, r16
	st X, r17
	push XH
	push XL
	ldi r16, 0x01 ;starting
	ldi r17, 0x02 ;spare
	ldi r18, 0x03 ;final		
	ldi XH, high(currentL)
	ldi XL, low(currentL)
	st X, r16
	push XH
	push XL
	ldi XH, high(spareL)
	ldi XL, low(spareL)
	st X, r17
	push XH
	push XL
	ldi XH, high(finalL)
	ldi Xl, low(finalL)
	st X, r18
	push XH
	push XL
	clr r0
	call TOH
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
	pop r16
done: jmp done


;returning in r0 the number of moves it took, it should be 2^n - 1
;if i want to go super hardcore can actually write some print statements to memory to see if its
;actually working properly or not
TOH:
	inc r0
	push ZH
	push ZL
	push XH
	push XL
	push YH
	push YL
	push r16 ;disk low 
	push r17 ;disk high
	push r18 ;currentL
	push r19 ;spareL
	push r20 ;finalL
	lds ZH, SPH
	lds ZL, SPL
	ldd XH, Z+22
	ldd XL, Z+21
	ldd YH, Z+20
	ldd YL, Z+19
	ld r16, X+
	ld r17, X
	ld r18, Y
	cpi r16, 0x00
	brne low_byte_not_zero
	cpi r17, 0x00
	brne high_byte_not_zero
	jmp finish

high_byte_not_zero:
	call check_r17 ;we have now stored the new number of disks

	ldd XH, Z+18
	ldd XL, Z+17
	ldd YH, Z+16
	ldd YL, Z+15
	ld r19, X
	ld r20, Y
low_byte_not_zero:
	ldd XH, Z+22
	ldd XL, Z+21
	dec r16
	st X, r16
	brne skip_check
	call check_r17
skip_check:
		


finish:
	pop r20
	pop r19
	pop r18
	pop r17
	pop r17
	pop YL
	pop YH
	pop XL
	pop XH
	pop ZL
	pop ZH
	ret

check_r17:
	cpi r17, 0x00
	breq skip
	dec r17
	ldi r16, 0xFF
	push XH
	push XL
	ldd XH, Z+24
	ldd XL, Z+23
	st X+, r16
	st X, r17
	pop XL
	pop XH
skip:
	ret

.dseg
disks: .byte 2
currentL: .byte 1 ; either 1,2,3
spareL: .byte 1 ; either 1,2,3
finalL: .byte 1; either 1,2,3
