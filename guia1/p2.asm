; Nombre    : p2.asm
;¿Qué hace el programa? 
; multiplica os números, resta 10 al resultado-
; divide entre 15, le resta 2 al cociente, suma 8 al resto,
; realiza cociente+resto y aplica OR con la máscara 

;Autor      : Manuel Fernández Mercado FCC BUAP
;Creación   : 19/08/2025
;Compilacion: nams -f elf p2.asm
;enlazar 	: ld -m elf_i386 -s p2.o io.o -o p2 


;NOTA!!! aún no realiza operaciones con signo y puede que de un error

%include "io.mac"

section .data 
	strFirst: db "Ingrese el primer numero:",0
	strSecond: db "Ingrese el segundo numero:",0
	strRes: db "El resultado es::",0

section .text
	global _start

_start:
	PutStr strFirst; obtiene el primer numero 
	GetLInt eax

	PutStr strFirst; obtiene el segundo numero
	GetLInt ebx

	MOV EDX, 0 ; limpia EDX para evitar errores en la multiplicación

	MUL EBX
	SUB EAX,10

	MOV EDX, 0; limpia el registro para evitar errores en la división 
	MOV EBX, 15; divide EAX entre 15
	DIV EBX

	SUB EAX,2; le resta 2 al cociente
	ADD EDX,8; le suma 8 al resto

	ADD EAX,EDX; suma cociente y resto
	OR EAX,00ACh; aplica una mascara al resultado

	PutStr strRes
	PutLInt EAX
	nwln
	;codigo para la terminación del programa
	MOV eax, 1
	int 80h
	
