;-------------------------------------------------------------------------------
; First asm code... with bugs!
;-------------------------------------------------------------------------------

;	THUMB
	AREA	|.text|, CODE, READONLY

	EXPORT	asm_main_1
	;EXPORT	result
	IMPORT	Ext_Buttons_Init
	IMPORT	Ext_Buttons_GetState
	IMPORT	Ext_LED_Init
	IMPORT	Ext_LEDs
	IMPORT	Ext_LED_PWM
	
asm_main_1 PROC
	
	bl Ext_Buttons_Init
	bl Ext_LED_Init
		
		
loop
	bl Ext_Buttons_GetState
	bl Ext_LEDs 
	b  loop 
	
	ENDP
	
	END
