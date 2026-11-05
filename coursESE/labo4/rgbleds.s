	THUMB
	AREA    |.text|, CODE, READONLY
;	AREA    |.data|, CODE, READWRITE, ALIGN=4

	IMPORT  SystemClock_Config
	EXPORT ledsInit
	EXPORT front
	EXPORT setLed
	EXPORT setMulLed

ledsInit	PROC
	
	mov pc, lr
	
front 						; cette fonction fait un front sur le clk de la led
	
	ldr r2, =0x40020418
	mov r0, #(1<<(14+16))
	mov r1, #(1<<(14))
	
	; mettre a 0 la pine
	str r0, [r2]
	; mettre a 1 la pine
	str r1, [r2]
	nop
	nop 
	nop
	nop 
	nop
	; mettre a 0 la pine
	str r0, [r2]
	
	; return
	mov pc, lr
	
	
setLed ; dans r0 le nombre de led, et à la suite, c'est la couleur des led		
	push {r4, r5, r6, lr}
	
	; déja faire que ce que on a dans r0 ca s'envoye dans r0 il y a la couleur
	
	ldr r5, = 0x40020414
	mov r4 , #32
	mov r6, r0
	
loop_32bit_send
	lsr r1, r6, r4  ; dans r1 j'ai si le bit est a 1 ou a 0
	lsl r1, #31
	lsr r1, #16
	str r1, [r5]
	nop
	nop 
	
	bl front
	subs r4, r4, #1
	bne loop_32bit_send
	
	
	pop {r4, r5, r6, pc}
	
setMulLed		; dans cette fonction on va aller chercer les variables dans le stack
	mov ip, sp
	push {r4, r5, r6, r7, lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3
	cmp r0, #0
	beq returnSetMulLed		; si il y a 0 led
	
	mov r0, r5
	bl setLed
	subs r4, r4, #1
	beq returnSetMulLed		; si il y a 1 led
	
	mov r0, r6
	bl setLed
	subs r4, r4, #1
	beq returnSetMulLed		; si il y a 2 led
	
	
	mov r0, r7
	bl setLed
	subs r4, r4, #1
	beq returnSetMulLed		; si il y a 4 led
ldLed
	; si le code passe ici les leds sont stoquée sur le stack
	ldr r0, [ip], #4
	bl setLed
	
	subs r4, r4, #1
	bne ldLed
	
	
returnSetMulLed
	pop {r4, r5, r6, r7, pc}

	

	
	
	
		ENDP
	AREA  |.data|, CODE, READWRITE, ALIGN=4

globalPower		DCD		1

	END