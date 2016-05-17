reset 		EQU 	000H
LTInt0 		EQU 	003H 	; local do tratador da Ext. 0
LTInt1		EQU		013H	; local do tratador da Ext. 1
state0 		EQU 	020H
flag0		EQU		PSW.5
flag1		EQU		PSW.1
	
	ORG 	reset 			; PC = 0 depois de reset
	JMP 	inicio
	
	ORG 	LTInt0			; Tratador 0
	JMP 	handler0
	
	ORG 	LTInt1			; Tratador 1
	JMP 	handler1
			
inicio: 	
	MOV 	IE,#10000101B 	; Habilita Int. Ext. 0 e 1
	SETB 	IT0 			; Habilita por borda
	SETB	IT1
	
	; Inicializa��o das vari�veis
	CLR 	flag0
	CLR		flag1
	MOV 	DPTR, #tabela
	MOV 	R1, #000H

; Programa principal que coloca 'Microprocessadores' na P1 com a interrup��o
loop: 		
	JNB 	flag0, loop
	CLR 	flag0
	MOV 	A, R1
	MOVC 	A, @A+DPTR
	MOV 	P1, A
	INC 	R1
	CJNE 	R1, #016H, loop
	JMP 	$

; Se houver interrup��o, set o flag0 permitindo colocar outra letra
handler0: 	
	JNB		flag1, nothing
	SETB 	flag0
nothing:	
	RETI

; Se houver interrup��o, troca o enable do flag0
handler1: 	
	CPL		flag1
	RETI

tabela: 	
	DB 		'Microcontrolador'
	
	END