	THUMB
	AREA    |.text|, CODE, READONLY
;	AREA    |.data|, CODE, READWRITE, ALIGN=4
	EXPORT ledsInit

ledsInit	PROC
	ldr r4, =0x40020414
	mov r0, #(1<<9)
	str r0, [r4]
	
	mov r0, #0x0
	str r0, [r4]
	
	mov pc, lr
	
	
	
	
		ENDP
	AREA  |.data|, CODE, READWRITE, ALIGN=4

globalPower		DCD		1

	END