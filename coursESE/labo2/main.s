;-----------------------------------------------------------------
; I5.12-ESE-Lab02-PTR
; Student code
;-----------------------------------------------------------------

	AREA |.text|, CODE, READONLY

		EXPORT	asm_main
		EXPORT	Answer
		EXPORT	Header
		EXPORT	Heap

		IMPORT	strOut
		IMPORT	strIn
		IMPORT	decIn
		IMPORT	decOut

next	EQU	0
name	EQU	4
age		EQU	12

asm_main PROC
	push	{lr}		; save return address
;------------------------ FIRST HEAP INIT ------------------------
	ldr	r0,=Heap		; get start of heap
	add	r1,r0,#4		; add 4 for next free block
	str	r1,[r0]			; store in start of heap
;------------------------ ASK CHOICE -----------------------------
loop
	ldr	r0,=MsgAsk
	bl	strOut			; display message
	ldr r0,=Answer
	mov	r1,#1
	bl	strIn			; read answer
	ldr	r0,=Answer
	ldrb	r0,[r0]		; get first char
;------------------------ CHECK CHOICE ---------------------------
	cmp	r0,#'N'
	beq	NewEntry		; new entry
	cmp	r0,#'n'
	beq	NewEntry		; new entry
	cmp	r0,#'V'
	beq	ViewDatabase	; view database
	cmp	r0,#'v'
	beq	ViewDatabase	; view database
	cmp	r0,#'D'
	beq	DeleteEntry		; delete an entry
	cmp	r0,#'d'
	beq	DeleteEntry		; delete an entry
	cmp	r0,#'S'
	beq	SortDatabase	; sort database
	cmp	r0,#'s'
	beq	SortDatabase	; sort database
	cmp	r0,#'Q'
	beq.w	Quit			; quit
	cmp	r0,#'q'
	beq.w	Quit			; quit
	b	loop
;=================================================================
;------------------------ NEW ENTRY ------------------------------
;=================================================================
NewEntry
; TODO add your code here

	ldr	r0,=MsgName
	bl	strOut			; display message
	mov r0, #4+8+4		; ask for 16 bytes
	bl New				; call new
	
						; Get the last personne and update the pointer
	ldr r4, =Header
	ldr r5, [r4]		; load in r5 what is in Header
	cmp r5, #0			; compare with 0
	streq r0, [r4]		; if equal store the value r0 in Header
	beq endLoopUpdateNewPerson	; jump end of the loop
loopUpdateNewPerson
	ldr r5, [r4]			; load the value of the pointer
	cmp r5, #0				
	movne r4, r5			; if r5 != 0 : r4 = r5;
	bne loopUpdateNewPerson ; if r5 != 0 : jump loop;
							; if r5 == 0 : affect the [r4] to the value
	str r0, [r4]						
endLoopUpdateNewPerson
	
	mov r4 , #0
	str r4, [r0]		; Set 0 the next pontiet to the new persone
	
	add r0, r0, #4		; Move 4 bytes to write the char
	
	mov	r1,#8-1			; Keep place for the '\0'
	bl	strIn			; read answer
	
	
	add r0, r0, #8		; Move 8 bytes to write the int
	
	mov r4, r0
	ldr	r0,=MsgAge
	bl	strOut			; display message
	bl	decIn			; read answer
	mov r5, r0			; value int in r5
	
	str r5, [r4]
	
	b	loop


;=================================================================
;------------------------ VIEW DATABASE --------------------------
;=================================================================
ViewDatabase
; TODO add your code here
	ldr r4, =Header
	ldr r5, [r4]		; load in r5 what is in Header
	cmp r5, #0			; compare with 0
	beq loop	; jump end of the loop
	
	movne r4, r5			; if r5 != 0 : r4 = r5;
loopViewPerson
	ldr r5, [r4]			; load the value of the pointer
	
	ldr	r0,=MsgDspName
	bl	strOut			; display message
	mov r0, r4
	add r0, r0, #4
	bl	strOut			; display Name
	ldr	r0,=MsgDspAge		; display message
	bl	strOut			; display Name
	ldr r0, [r4 , #12]		; display Age
	bl	decOut			; display message
	
	
	
	
	cmp r5, #0				
	movne r4, r5			; if r5 != 0 : r4 = r5;
	bne loopViewPerson ; if r5 != 0 : jump loop;
	

	B	loop			; yes -> return


;=================================================================
;------------------------ DELETE ENTRY ---------------------------
;=================================================================
DeleteEntry
; TODO add your code here
	ldr	r0,=MsgName
	bl	strOut			; display message
	mov r6, #0
	ldr r0, =Answer 
	str r6, [r0]
	str r6, [r0, #4]
	mov	r1,#8-1			; Keep place for the '\0'
	bl	strIn			; read answer
	ldr r6, [r0]		; get the name in the r6
	ldr r7, [r0, #4]		; get the name in the r7
	
	
	ldr r4, =Header		; get the addr of the header
		
loopDelPerson
	ldr r5, [r4]		; load in r5 what is in Header
	cmp r5, #0			; compare with 0
	beq loop			; jump end of the loop if equal
	ldr r8, [r5, #4]		; load the first 4 char in r8
	ldr r9, [r5, #8]		; load the next 4 char in r9
	; compare r8 et r6 ainsi que r7 et r9
	cmp r6, r8
	bne notEqual
	cmp r7, r9
	bne notEqual	
	
	mov r10, r4
	cmp r4, #0
	ldrne r4, [r4]
	cmp r4, #0
	ldrne r4, [r4]
	str r4, [r10]
	b loop
	
	
notEqual
	ldr r4, [r4]
	cmp r4, #0
	bne loopDelPerson ; if r5 != 0 : jump loop;
	b loop 				; if the name is not in the boucle we stop

	


	
	B	loop

;=================================================================
;------------------------ SORT DATABASE --------------------------
;=================================================================
SortDatabase
; TODO add your code here

	; get the len of the pointer chain dans r6
	ldr r4, =Header
	mov r6, #0
getLenChain
	ldr r4, [r4]
	cmp r4, #0
	addne r6, r6, #1	
	bne getLenChain
	
	sub r6, r6, #1
	cmp r6, #1
	beq loop
	
; ici le r6 c'est poru la grande boucle le r7 c'est la petite boucle
	
bigLoop 
	ldr r4, =Header
	ldr r5, [r4]
	ldr r4, [r4]
	ldr r5, [r5]
smallLoop
	; loop
	; confdition to change
	ldr r8, [r4, #4+8]
	ldr r9, [r5, #4+8]
	cmp r8, r9
	bmi noChange
	
	ldr r8, [r5]
	str r8, [r4]
	ldr r8, [r8]
	str r8, [r5]
	ldr r8, [r4]
	str r4, [r8]
noChange
	
	mov r4, r5
	ldr r5, [r5]
	
	; end loop
	sub r7, r7, #1		
	cmp r7, #0
	beq smallLoop
	
					
	sub r6, r6, #1		
	cmp r6, #0
	bne bigLoop
	
	
	; loop in the boucle 
	
	
	; if greater than the next switch


	B	loop
;=================================================================
;------------------------ QUIT -----------------------------------
;=================================================================
Quit
	pop	{pc}			; restore return address

	ENDP
;=================================================================
; Function  : New
; Goal      : Allocate memory from Heap
; Input     : r0 - size in bytes to allocate
; Output    : r0 - Address of reserved zone
;=================================================================
New
	push  {r1-r2,lr}	  ; save registers
	ldr	  r1,=Heap		  ; get heap address
	ldr	  r2,[r1]		  ; get free address
	add	  r0,r0,r2		  ; add offset to free address
	str	  r0,[r1]	  	  ; store it in heap address
	mov	  r0,r2			  ; return free address
	pop	  {r1-r2,pc}	  ; restore registers and return

;=================================================================

MsgAsk		DCB	"\nMake your choice (N,V,D,S,Q) :",0
MsgName		DCB	"\nEnter the name : ",0
MsgAge		DCB	"\nEnter the age : ",0
MsgDspName	DCB	"\nName : ",0
MsgDspAge	DCB	" Age : ",0
MsgToDelete	DCB	"\nName to delete : ",0

GetChar		DCB	"%c",0

;-----------------------------------------------------------------
; Data section
;-----------------------------------------------------------------
	AREA  |.data|, DATA, READWRITE, ALIGN=8
Header		DCD 	0
Heap		SPACE	4096

	ALIGN 8

Answer		SPACE	8

	END