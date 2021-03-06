;Programa ESCREVE_MSG.asm
CS 			EQU P0.7
EN 			EQU P1.2
RS_0 		EQU 000H
RS_1 		EQU 00001000b
Atraso 		EQU 050H

	ORG 	000H
	CLR 	CS 			; INIBE DECODIFICADOR DOS DISPLAYS DE 7 SEGMENTOS
	CALL 	INITDSP 	; ROTINA QUE CONFIGURA CONTROLADOR LCD
	
	;ESCREVE MENSAGEM
	
	MOV 	DPTR, #MENS
	MOV 	R2, #RS_1 	; SETB P1.3 (RS) - ENVIO DE DADO para LCD
	CALL 	WRT
MAIN:
	MOV 	R2, #RS_1
	MOV		A, P2
	CPL		A
	
	PUSH	ACC
	ANL		A, #0F0H
	SWAP	A
	CALL 	CONVERTE
	CALL	WRT2
	
	POP		ACC
	ANL		A, #00FH
	CALL 	CONVERTE
	CALL	WRT2
	
	MOV 	R2, #RS_0
	MOV		A, #086H	; Anda com o cursor para tr�s
	CALL	WRT2
	JMP		MAIN
	
MENS: 
	DB 		006H, "Valor "
	
DELAY: 
	MOV 	R0, #Atraso
	DJNZ 	R0, $
	RET
			
INITDSP: 
	; subrotina para inicializar o display
	; 001(DL)_NFxx = 0010 1000b (function set)
	; DL=0: interface 4 bits; N=1: 2 linhas; F=0: caractere 5x8
	; En (P1.2): 1-> 0 = escreve; RS (P1.3): 0=comando;1=dado
	MOV 	P1,#20H 	; FUNCTION SET - high nibble = 0010b -- interface 4 bits
	SETB 	EN 			; GERA EN
	CLR 	EN
	CALL 	DELAY 		; AGUARDA LCD FICAR PRONTO
	
	; Nibble alto do Function Set � enviado 2x.
	
	MOV 	R2, #RS_0 	; CLR P1.3 (RS) - comando vai ser enviado para LCD
	MOV 	DPTR, #comando
	CALL 	WRT 		; escreve dados para o LCD
	RET

; nro. de comandos - function set - display on/off - entry mode
comando: 
	DB 		003h, 028h, 00fh, 006h
	
WRT:	
	MOV 	A, #0 		; END. DO NRO DE COMANDOS/DADOS
	MOVC 	A, @A+DPTR
	MOV 	R6, A 		; R6=NRO DE COMANDOS/DADOS
	MOV 	R1, #1H 	; DESLOCAMENTO DO COMANDO/MENSAGEM INICIAL

LOOP:	
	MOV 	A, R1 		; END. DO PRIMEIRO DADO/COMANDO EM A
	MOVC 	A, @A+DPTR
	CALL	WRT2
	INC 	R1 			; R1 APONTA PARA PR�XIMO COMANDO/DADO
	DJNZ 	R6, LOOP 	; VERIFICA SE �LTIMO DADO/COMANDO
	RET

WRT2:
	MOV 	B, A 		; BYTE A SER ESCRITO EM B
	ANL 	A, #0F0H 	; APAGA NIBBLE LS
	ORL 	A, R2 		; R2 DEVE CONTER RS (0: COMANDO; 8: DADO) ou seja valor de P1.3
	MOV 	P1, A 		; ENVIA PARA LCD
	SETB 	EN 			; GERA EN
	CLR 	EN
	
	MOV 	A, B
	SWAP 	A 			;TROCA NIBBLES MS-LS
	ANL 	A, #0F0H 	; APAGA NIBBLE LS
	ORL 	A, R2 		; SETB P1.3 (RS) se R2 = RS_1;
	MOV 	P1, A 		; ENVIA PARA LCD
	SETB 	EN 			; GERA EN
	CLR 	EN
	CALL 	DELAY 		; AGUARDA LCD ESTAR PRONTO PARA NOVO COMANDO
	RET

CONVERTE: 
	INC		A
	MOVC 	A, @A+PC
	RET
				
TABELA:
	DB 		030H, 031H, 032H, 033H, 034H, 035H, 036H, 037H, 038H, 039H, 041H, 042H, 043H, 044H, 045H, 046H
	
	END