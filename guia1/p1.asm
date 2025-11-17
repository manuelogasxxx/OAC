; Nombre    : p1.asm
;el programa hace la operación aritmética X=[(A*B)/(C-D)]+E
;Autor      : Manuel Fernández Mercado FCC BUAP
;Creación   : 19/08/2025
;Compilacion: nams -f elf p1.asm
;enlazar 	: ld -m elf_i386 -s p1.o io.o -o p1 

;correcciones, poner GetLInt
;las operaciones se van realizando a la par que se escanean los datos

%include "io.mac"
section .data

	strA: db "Ingrese A:",10,0
	strB: db "Ingrese B:",10,0
	strC: db "Ingrese C:",10,0
	strD: db "Ingrese D:",10,0
	strE: db "Ingrese E:",10,0
	strRes: db "El resultado es:",10,0


section .text

global _start

_start:
	PutStr strA; captura el valor A
	GetLInt eax
	
	PutStr strB; Captura el valor B
	GetLInt ebx

	MUL EBX; MUltiplica A*B y lo guarda en la pila 

	PUSH EAX

	XOR EBX,EBX ; limpiar el registro EBX para evitar errores 

	PutStr strC; captura el valor de C
	GetLInt EBX
	
	PutStr strD; captura el valor de D
	GetLInt EAX

	SUB EBX,EAX
	POP EAX; recupero A*B
	DIV EBX; realizo (A*B)/(C-D)

	XOR EBX,EBX ; limpiar el registro EBX para capturar un nuevo valor

	PutStr strE
	GetLInt EBX; toma la E

	ADD EAX, EBX
	
	PutStr strRes; ;ya se va a mostrar el resultado
	PutLInt EAX
	nwln
	
	;codigo para la terminación del programa
	MOV eax, 1
	INT 80h
