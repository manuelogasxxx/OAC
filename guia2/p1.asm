;nombre    : p1.asm
;Propósito : Saber si tres números son triangulares
;autor     : Manuel Fernández Mercado
;FCreacion : 27/08/2025
;FModif    : 28/08/2025
;compilar  :
;			 nasm -f elf32 p1.asm
;			 ld -m elf_i386 -s -o p1 p1.o io.o


%include "io.mac"


section .data

	strFirst : db "Ingrese el primer numero::",10,0
	strSecond: db "Ingrese el segundo numero::",10,0
	strThird : db "Ingrese el tercer numero::",10,0
	strTriangle: db "SI son triangulares",10,0
	strNotTriangle: db "NO son triangulares",10,0


section .text

global _start


_start:
	;es mejor 
	PutStr strFirst ; A
	GetLInt EAX
	push eax 

	PutStr strSecond; B
	GetLInt EBX
	push ebx 

	PutStr strThird ; C
	GetLInt EDX
	push edx

	ADD EBX, EAX ; realizo A+B 
	cmp EDX, EBX  ; C>a+b
	jns notTriangle
	
	pop ebx		 ; recupero el valor de C
	add ebx, eax ; realizo C+A
	pop EDX 	 ; recupero el valor de B
	cmp EDX,EBX  ; B>A+C
	jns notTriangle
	 
	sub EBX,EAX  ; recupero el valor original de C
	add EBX,EDX  ; realizo C+B
	cmp EAX,EBX
	jns notTriangle
	PutStr strTriangle
	jmp fin

	notTriangle:
	PutStr strNotTriangle
	jmp fin

	
	fin:	

	MOV eax,01
	INT 80h
