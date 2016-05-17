; Mover para mem�ria externa
xMem		EQU		02000H		; Primeira maneira utilizando DPTR
xMemLS		EQU		000H		; Segunda maneira utilizando registrador e porta P2
xMemMS		EQU		020H

	; Primeira maneira
	MOV		DPTR, #xMem
	MOVX	A, @DPTR		; L� da mem�ria o que tem na posi��o apontada por DPTR e salva em A
	MOVX	@DPTR, A		; Salva na mem�ria o conte�do de A na posi��o apontada por DPTR
	
	; Segunda maneira, melhor quando MS nibble � fixo
	MOV		P2, #xMemMS		; A porta P2 fica respons�vel por apontar a parte MS da posi��o da mem�ria
	MOV		R1, #xMemLS		; Ou um valor que se altera no c�digo. Precisa ser R0 ou R1
	MOVX	A, @R1			; L� da mem�ria o que tem na posi��o apontada por R0 ou R1 e salva em A
	MOVX	@R1, A			; Salva na mem�ria o conte�do de A na posi��o apontada por R0 ou R1