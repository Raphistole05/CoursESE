	AREA    |.text|, CODE, READONLY

      EXPORT  asm_main
      IMPORT  Ext_Debug_Init
      IMPORT  SystemClock_Config
		  
      EXPORT TableA
      EXPORT TableB

asm_main PROC
	
	bl SystemClock_Config
	ldr r0, =0xE000E010
	mov r2, #0
	str r2, [r0]
	bl Ext_Debug_Init

	ldr r1, =output
	ldr r1, [r1]		; dans r1 j'ai l'adresse ou il faut les outputs
	mov r3, #0x200
loop
	str r3, [r1]
	ldr    r4,=TableA
	ldr    r5,=TableB
	mov    r6,#TableB-TableA
copy
	ldr   r7,[r4],#4
	str   r7,[r5],#4
	subs   r6,r6,#4
	bne    copy
	
	str r2, [r1]
	
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
output 		DCD 	0x40021414
	END
