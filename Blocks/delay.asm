; Criando um atraso
delayAm		EQU		0FFH
	
	; Inicializa��o
	MOV		R3, #000H
	MOV		R4, #000H
	
	CALL	delay	; Chamada do delay
	
delay: 		; Inicializa��o do delay
	MOV		R3, delayAm
	MOV		R4, delayAm
delayL:		; Loop do delay
	DJNZ	R3, delayL
	MOV		R3, delayAm
	DJNZ	R4, delayL
	RET