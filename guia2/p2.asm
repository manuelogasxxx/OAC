;nombre    : p2.asm
;Propósito : Saber de dos personas quien es la mayor
;autor     : Manuel Fernández Mercado
;FCreacion : 27/08/2025
;FModif    : 28/08/2025
;compilar  :
;			 nasm -f elf32 p3.asm
;			 ls -m elf_i386 -s -o p3 p3.o io.o
;aún no compruebo si los meses están o no en rango adecuado
%include "io.mac"

section .data
	msjP1: db "::Persona 1::",10,0
	msjP2: db "::Persona 2::",10,0
	msjDay: db "Ingrese el dia::",10,0
	msjMonth: db "Ingrese el mes::",10,0
	msjYear: db "ingrese el año::",10,0

	msjP1Mayor: db "La PRIMER persona es mayor",10,0
	msjP2Mayor: db "La SEGUNDA persona es mayor",10,0
	msjSame: db "Tienen la misma edad",10,0


section .text
global _start

_start:

	PutStr msjP1
	PutStr msjDay
	GetLInt EAX
	push EAX
	XOR EAX, EAX
	
	PutStr msjMonth
	GetLInt EAX
	push EAX
	XOR EAX, EAX
	
	PutStr msjYear
	GetLInt EAX
	;aquí ya tengo todos la fecha de la primer persona	

	PutStr msjP2
	PutStr msjDay
	GetLInt EBX ; día de la segunda persona
	
	PutStr msjMonth
	GetLInt ECX ; mes de la segunda persona
	
	PutStr msjYear
	GetLInt EDX ; año de la segunda persona

	;primero comparo los años

	CMP EAX, EDX
	JNE checkYear
	;continua si son iguales
	;comprueba los meses
	POP EAX; recupero los meses de la primer persona
	CMP EAX,ECX
	JNE checkMonth
	;continua si los meses son iguales

	POP EAX; recupero los meses de la primer persona
	CMP EAX,EBX
	JNE checkDay
	;Coinciden en todo
	PutStr msjSame
	JMP fin

	checkYear:
		JS primeroMayor
		JMP segundoMayor

	checkMonth:
		JS primeroMayor
		JMP segundoMayor
		
	checkDay:
		JS primeroMayor
		JMP segundoMayor		



	primeroMayor:
		PutStr msjP1Mayor
		JMP fin
	segundoMayor:
		PutStr msjP2Mayor
		JMP fin

	fin:
		mov eax,01
		int 80h



