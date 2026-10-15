	AREA    |.text|, CODE, READONLY

      EXPORT  asm_main
      IMPORT  Ext_Debug_Init
      IMPORT  SystemClock_Config
		IMPORT memcpy
		  
      EXPORT TableA
      EXPORT TableB

asm_main PROC
	
	
	bl SystemClock_Config
	ldr r0, =0xE000E010
	mov r2, #0
	str r2, [r0]
	
	bl Ext_Debug_Init

	ldr r4, =0x40021414
	;ldr r1, [r1]		; dans r1 j'ai l'adresse ou il faut les outputs
	mov 	r3, #0x200
	mov 	r0, #0
	
	
loop

	ldr    r1,=TableA
	ldr    r0,=TableB
	mov    r2,#TableB-TableA
	
	
	mov 	r3, #0x200
	str 	r3, [r4]
	
	bl memcpy
	
	
	mov r3, #0
	str r3, [r4]

	
	b    loop
	ENDP

;-------------------------------------------------------------------
; Data section
;-------------------------------------------------------------------
	AREA  |.data|, DATA, READWRITE, ALIGN=4
TableA		DCB 	"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
			DCB 	"abcdefghijklmnopqrstuvwxyz+-.,<>()/#"
endTableA
TableB		SPACE   endTableA-TableA
	END
