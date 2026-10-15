	AREA    |.text|, CODE, READONLY

      EXPORT  asm_main
      IMPORT  Ext_Debug_Init
      IMPORT  SystemClock_Config

asm_main PROC

loop
      ldr    r4,=TableA
      ldr    r5,=TableB
      mov    r6,#TableB-TableA
copy
      ldrb   r7,[r4],#1
      strb   r7,[r5],#1
      subs   r6,r6,#1
      bne    copy

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
