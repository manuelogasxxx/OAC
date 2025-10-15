; valor y posición de la primer ocurrencia del elemento mas frecuente



%include "io.mac"
section .data
	proposito db "Verifica  valor y posición de la primer ocurrencia del elemento mas frecuente en un arreglo",10,0

	tamano  db "Ingrese el tamaño del arreglo::",10,0
	datos db "Ingrese los datos del vector::",10,0
	valor db "valor  en la posicion  ",0 
	resultado db "Valor mas frecuente del arreglo::",0
	posicion db "Posicion::",0
	max_valor dd 0
	max_ocurrencia dd 0
	max_pos dd 0
	aux_valor dd 0
	aux_ocurrencia dd 0
	aux_pos dd 0
	

section .bss
	nroElementos resd 1
	vector resd 1000
	vectorAux resd 500

section .text

global _start

_start:

PutStr proposito
PutStr tamano
GetInt [nroElementos]

;solicitar datos del arreglo
leer_datos:
	PutStr datos
	XOR ESI,ESI
	MOV ECX,[nroElementos]
leer_siguiente:
	PutStr valor
	PutLInt ESI
	nwln
	GetLInt EAX
	
	mov [vector +ESI*4],EAX
	INC ESI 
	LOOPNZ leer_siguiente

;set termino la lectura
XOR ESI,ESI 
MOV ECX, [nroElementos]

;mostrar el arreglo 

;se va a hacer un ciclo anidado
bucleExterno:
	MOV EDX,[vector +ESI*4]; EDX tiene el valor a buscar
	MOV [aux_pos],ESI; la posición del valor
	MOV [aux_valor],EDX 
	Push ESI
	PUSH ECX
	;inicializo el siguiente ciclo
	XOR ESI,ESI 
	MOV ECX, [nroElementos]
	XOR EAX,EAX;va a ser el contador de las ocurrencias
	bucleInterno:
	 	MOV EBX,[vector +ESI*4]  
		CMP EDX, EBX
		JNE siguiente
		ADD EAX,1 
		siguiente:
			INC ESI
	LOOPNZ bucleInterno
	
	;sale del bucle interno
	CMP EAX,[max_ocurrencia]
	JL sigIteracion
	JE mismaOcurrencia
	;si es mayor
	;actualiza el mayor
	MOV [max_ocurrencia],EAX ;ocurrencia
	MOV [max_valor],EBX		 ;valor
	MOV EBX,[aux_pos]
	MOV [max_pos],EBX
	JMP sigIteracion
	mismaOcurrencia:
		;misma ocurrencia toma el indice menor
		MOV EBX, [aux_pos]
		CMP EBX, [max_pos]
		JG sigIteracion
		;se actualiza el valor máximo
		MOV [max_ocurrencia],EAX ;ocurrencia
		MOV [max_valor],EBX		 ;valor
		MOV EBX,[aux_pos]
		MOV [max_pos],EBX
		jmp sigIteracion
	;
	sigIteracion:
		;extraigo los valores guardados de la Pila
		POP ECX
		POP ESI
		INC ESI
	LOOPNZ bucleExterno

	;impresion de los resultados finales		
	PutStr resultado
	PutLInt [max_valor]
	nwln
	PutStr posicion
	PutLInt [max_pos]
	nwln
	jmp fin

fin:
	MOV EAX,01
	INT 80h






