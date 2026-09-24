;-------------------------------------------------------------------------------
; First asm code... with bugs!
;-------------------------------------------------------------------------------

;	THUMB
	AREA	|.text|, CODE, READONLY

	EXPORT	asm_main
	EXPORT	result
	IMPORT	Ext_Buttons_Init
	IMPORT	Ext_Buttons_GetState
	IMPORT	Ext_LED_Init
	IMPORT	Ext_LEDs
	IMPORT	Ext_LED_PWM


ledDown		RN 3				; name for register alias
ledUp		RN 4
seqCnt		RN 5
dtyDown		RN 7
dtyUp		RN 6

asm_main  PROC
	bl  Ext_Buttons_Init		; init buttons
	bl  Ext_LED_Init			; init LEDs
	mov	seqCnt,#0				; clear sequence counter
	mov ledDown,#1				; led to clear is 0
	mov ledUp,#2				; led to set is 1
loop_k2000
;-------------------------------------------------------------------------------
	mov	dtyDown,#100			; intensity max is 100
	mov	dtyUp,#0				; intensity min is 0
lp_1
	mov	r0,ledDown				; first parameter
	mov	r1,dtyDown				; second parameter
	bl	Ext_LED_PWM				; set led power
	mov	r0,ledUp				; first parameter
	mov	r1,dtyUp				; second parameter
	bl	Ext_LED_PWM				; set led power
	bl	wait					; wait a moment (dummy loop)
	add dtyUp,dtyUp,#1			; increment led power
	subs dtyDown,dtyDown,#1		; decrement led power
	bne	lp_1					; until 0
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	add seqCnt,seqCnt,#1		; increment sequence counter
	cmp	seqCnt,#s_len			; check end of sequence
;	it		eq					; IT BLOCK - EQUAL
	moveq	seqCnt,#0			;   clear counter if reach sizeof sequence
	ldr r0,=sequence			; get sequence address
	ldrb	ledDown,[r0,seqCnt]	; get next led down value
	cmp		seqCnt,#s_len-1		; compare counter to end of sequence
;	itee	eq					; IT BLOCK - EQUAL
	ldrbeq	ledUp,[r0]			;   equal -> get led up position 0
	addne	r1,seqCnt,#1		;   not   -> increment offset
	ldrbne	ledUp,[r0,r1]		;            get led up position
	b	loop_k2000				; loop animation
	ENDP

;-------------------------------------------------------------------------------
wait
	mov  r0,#40000				; for a certain delay
lp
	subs r0,r0,#1				; decrement
	bne  lp						; loop until 0
	bx   lr						; return
;-------------------------------------------------------------------------------
sequence	DCB 1,2,4,8,4,2		; sequence of LEDs numbers
length
s_len       EQU length-sequence	; gets length of sequence

;-------------------------------------------------------------------------------
; example of data section (not used)
;-------------------------------------------------------------------------------
	AREA	|.data|, DATA, READWRITE, ALIGN=4
result		DCD  1

	END
